from flask import Flask, render_template, request, redirect, url_for, flash, session, jsonify
from flask_mysqldb import MySQL
import MySQLdb.cursors
from config import config
import re

app = Flask(__name__)

# 使用配置类
app.config.from_object(config['development'])

# 初始化MySQL
mysql = MySQL(app)

@app.route('/')
@app.route('/home')
def home():
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute('SELECT * FROM movies')
    movies = cursor.fetchall()
    return render_template('shouye.html', movies=movies)

@app.route('/denglu', methods=['GET', 'POST'])
def denglu():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM users WHERE username = %s AND password = %s', (username, password,))
        user = cursor.fetchone()
        
        if user:
            session['loggedin'] = True
            session['username'] = user['username']
            return redirect(url_for('home'))
        else:
            flash('用户名或密码错误')
    return render_template('denglu.html')

@app.route('/zhuce', methods=['GET', 'POST'])
def zhuce():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        email = request.form['email']
        
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM users WHERE username = %s', (username,))
        account = cursor.fetchone()
        
        if account:
            flash('该用户名已存在')
            return redirect(url_for('zhuce'))
        else:
            try:
                cursor.execute('''
                    INSERT INTO users (username, password, email) 
                    VALUES (%s, %s, %s)
                ''', (username, password, email))
                mysql.connection.commit()
                session['register_success'] = True
                return redirect(url_for('denglu'))
            except Exception as e:
                mysql.connection.rollback()
                flash('注册失败，请稍后重试')
                return redirect(url_for('zhuce'))
    return render_template('zhuce.html')

@app.route('/logout')
def logout():
    session.pop('loggedin', None)
    session.pop('username', None)
    return redirect(url_for('home'))

@app.route('/movie/<int:movie_id>')
def movie_detail(movie_id):
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute('SELECT * FROM movies WHERE id = %s', (movie_id,))
    movie = cursor.fetchone()
    
    # 获取电影评论
    cursor.execute('''
        SELECT comments.*, users.username 
        FROM comments 
        JOIN users ON comments.user_id = users.id 
        WHERE movie_id = %s 
        ORDER BY created_at DESC
    ''', (movie_id,))
    comments = cursor.fetchall()
    
    return render_template('movie_detail.html', movie=movie, comments=comments)

# 个人中心路由
@app.route('/profile')
def profile():
    if 'loggedin' not in session:
        return redirect(url_for('denglu'))
    
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    
    # 获取用户信息
    cursor.execute('SELECT * FROM users WHERE username = %s', (session['username'],))
    user = cursor.fetchone()
    
    # 获取收藏的电影
    cursor.execute('''
        SELECT movies.* FROM movies 
        JOIN favorites ON movies.id = favorites.movie_id 
        WHERE favorites.user_id = %s
    ''', (user['id'],))
    favorite_movies = cursor.fetchall()
    
    # 获取用户的评论
    cursor.execute('''
        SELECT comments.*, movies.title as movie_title 
        FROM comments 
        JOIN movies ON comments.movie_id = movies.id 
        WHERE user_id = %s 
        ORDER BY created_at DESC
    ''', (user['id'],))
    user_comments = cursor.fetchall()
    
    return render_template('profile.html', 
                         user=user, 
                         favorite_movies=favorite_movies,
                         user_comments=user_comments)

# 修改个人信息
@app.route('/update_profile', methods=['POST'])
def update_profile():
    if 'loggedin' not in session:
        return redirect(url_for('denglu'))
    
    email = request.form['email']
    new_password = request.form['new_password']
    
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    if new_password:
        cursor.execute('UPDATE users SET email = %s, password = %s WHERE username = %s', 
                      (email, new_password, session['username']))
    else:
        cursor.execute('UPDATE users SET email = %s WHERE username = %s', 
                      (email, session['username']))
    
    mysql.connection.commit()
    flash('个人信息更新成功')
    return redirect(url_for('profile'))

# 收藏/取消收藏电影
@app.route('/toggle_favorite/<int:movie_id>', methods=['POST'])
def toggle_favorite(movie_id):
    if 'loggedin' not in session:
        return jsonify({'status': 'error', 'message': '请先登录'})
    
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute('SELECT id FROM users WHERE username = %s', (session['username'],))
    user = cursor.fetchone()
    
    # 检查是否收藏
    cursor.execute('SELECT * FROM favorites WHERE user_id = %s AND movie_id = %s', 
                  (user['id'], movie_id))
    favorite = cursor.fetchone()
    
    if favorite:
        # 取消收藏
        cursor.execute('DELETE FROM favorites WHERE user_id = %s AND movie_id = %s', 
                      (user['id'], movie_id))
        status = 'unfavorited'
    else:
        # 添加收藏
        cursor.execute('INSERT INTO favorites (user_id, movie_id) VALUES (%s, %s)', 
                      (user['id'], movie_id))
        status = 'favorited'
    
    mysql.connection.commit()
    return jsonify({'status': 'success', 'action': status})

@app.route('/check_favorite/<int:movie_id>')
def check_favorite(movie_id):
    if 'loggedin' not in session:
        return jsonify({'is_favorite': False})
    
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute('SELECT id FROM users WHERE username = %s', (session['username'],))
    user = cursor.fetchone()
    
    cursor.execute('SELECT * FROM favorites WHERE user_id = %s AND movie_id = %s', 
                  (user['id'], movie_id))
    favorite = cursor.fetchone()
    
    return jsonify({'is_favorite': favorite is not None})

@app.route('/update_username', methods=['POST'])
def update_username():
    if 'loggedin' not in session:
        return redirect(url_for('denglu'))
    
    new_username = request.form['new_username']
    
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    
    # 检查新用户名是否已存在
    cursor.execute('SELECT * FROM users WHERE username = %s', (new_username,))
    existing_user = cursor.fetchone()
    
    if existing_user:
        flash('该用户名已被使用')
        return redirect(url_for('profile', show_modal='true', modal_type='username'))
    
    try:
        # 更新用户名
        cursor.execute('UPDATE users SET username = %s WHERE username = %s', 
                      (new_username, session['username']))
        mysql.connection.commit()
        
        # 更新session中的用户名
        session['username'] = new_username
        
        flash('用户名修改成功！')
        return redirect(url_for('profile'))
    except Exception as e:
        mysql.connection.rollback()
        flash('用户名修改失败，请稍后重试')
        return redirect(url_for('profile', show_modal='true', modal_type='username'))

@app.route('/update_email', methods=['POST'])
def update_email():
    if 'loggedin' not in session:
        return redirect(url_for('denglu'))
    
    old_email = request.form['old_email']
    new_email = request.form['new_email']
    confirm_email = request.form['confirm_email']
    
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    
    # 验证原邮箱
    cursor.execute('SELECT * FROM users WHERE username = %s AND email = %s', 
                  (session['username'], old_email))
    account = cursor.fetchone()
    
    if not account:
        flash('原邮箱输入错误')
        return redirect(url_for('profile', show_modal='true', modal_type='email'))
    
    if new_email != confirm_email:
        flash('两次输入的新邮箱不一致')
        return redirect(url_for('profile'))
    
    try:
        cursor.execute('UPDATE users SET email = %s WHERE username = %s', 
                      (new_email, session['username']))
        mysql.connection.commit()
        flash('邮箱修改成功！')
        return redirect(url_for('profile'))
    except Exception as e:
        mysql.connection.rollback()
        flash('邮箱修改失败，请稍后重试')
        return redirect(url_for('profile'))

@app.route('/change_password', methods=['POST'])
def change_password():
    if 'loggedin' not in session:
        return redirect(url_for('denglu'))
    
    old_password = request.form['old_password']
    new_password = request.form['new_password']
    confirm_password = request.form['confirm_password']
    
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    
    # 验证原密码
    cursor.execute('SELECT * FROM users WHERE username = %s AND password = %s', 
                  (session['username'], old_password))
    account = cursor.fetchone()
    
    if not account:
        flash('原密码错误，请重新输入')
        return redirect(url_for('profile', show_modal='true', modal_type='password'))
    
    if new_password != confirm_password:
        flash('两次输入的新密码不一致，请重新输入')
        return redirect(url_for('profile'))
    
    try:
        cursor.execute('UPDATE users SET password = %s WHERE username = %s', 
                      (new_password, session['username']))
        mysql.connection.commit()
        flash('密码修改成功！')
        return redirect(url_for('profile'))
    except Exception as e:
        mysql.connection.rollback()
        flash('密码修改失败，请稍后重试')
        return redirect(url_for('profile'))

# 添加评论
@app.route('/movie/<int:movie_id>/comment', methods=['POST'])
def add_comment(movie_id):
    if 'loggedin' not in session:
        return redirect(url_for('denglu'))
    
    content = request.form['content']
    
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute('SELECT id FROM users WHERE username = %s', (session['username'],))
    user = cursor.fetchone()
    
    cursor.execute('INSERT INTO comments (user_id, movie_id, content) VALUES (%s, %s, %s)',
                  (user['id'], movie_id, content))
    mysql.connection.commit()
    
    flash('评论发表成功')
    return redirect(url_for('movie_detail', movie_id=movie_id))

# 删除评论
@app.route('/delete_comment/<int:comment_id>', methods=['POST'])
def delete_comment(comment_id):
    if 'loggedin' not in session:
        return jsonify({'status': 'error', 'message': '请先登录'})
    
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    
    # 验证评论是否属于当前用户
    cursor.execute('''
        SELECT comments.*, users.username 
        FROM comments 
        JOIN users ON comments.user_id = users.id 
        WHERE comments.id = %s AND users.username = %s
    ''', (comment_id, session['username']))
    comment = cursor.fetchone()
    
    if not comment:
        return jsonify({'status': 'error', 'message': '没有权限删除此评论'})
    
    try:
        cursor.execute('DELETE FROM comments WHERE id = %s', (comment_id,))
        mysql.connection.commit()
        return jsonify({'status': 'success'})
    except Exception as e:
        mysql.connection.rollback()
        return jsonify({'status': 'error', 'message': '删除失败，请稍后重试'})

@app.route('/change_username_page')
def change_username_page():
    if 'loggedin' not in session:
        return redirect(url_for('denglu'))
    return render_template('change_username.html')

@app.route('/change_email_page')
def change_email_page():
    if 'loggedin' not in session:
        return redirect(url_for('denglu'))
    return render_template('change_email.html')

@app.route('/change_password_page')
def change_password_page():
    if 'loggedin' not in session:
        return redirect(url_for('denglu'))
    return render_template('change_password.html')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)