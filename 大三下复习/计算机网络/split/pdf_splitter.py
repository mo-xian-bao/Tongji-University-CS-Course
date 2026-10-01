import streamlit as st
from PyPDF2 import PdfReader, PdfWriter
import fitz  # PyMuPDF
import io

st.set_page_config(page_title="PDF 拆分工具", page_icon="📄", layout="wide")
st.title("📄 PDF 拆分工具")

uploaded_file = st.file_uploader("上传 PDF 文件", type="pdf")

if uploaded_file:
    pdf_bytes = uploaded_file.read()
    pdf_reader = PdfReader(io.BytesIO(pdf_bytes))
    total_pages = len(pdf_reader.pages)
    
    st.info(f"文件共 {total_pages} 页")
    
    # 页码选择
    col1, col2 = st.columns(2)
    with col1:
        start_page = st.number_input("起始页", min_value=1, max_value=total_pages, value=1)
    with col2:
        end_page = st.number_input("结束页", min_value=1, max_value=total_pages, value=total_pages)
    
    # PDF 预览
    st.subheader("📖 页面预览")
    doc = fitz.open(stream=pdf_bytes, filetype="pdf")
    
    # 每行显示3页
    cols_per_row = 5
    for i in range(0, total_pages, cols_per_row):
        cols = st.columns(cols_per_row)
        for j, col in enumerate(cols):
            page_idx = i + j
            if page_idx < total_pages:
                page = doc[page_idx]
                pix = page.get_pixmap(matrix=fitz.Matrix(0.5, 0.5))  # 缩小以提高性能
                img_bytes = pix.tobytes("png")
                
                with col:
                    # 高亮选中的页面
                    is_selected = start_page <= (page_idx + 1) <= end_page
                    border_color = "#4CAF50" if is_selected else "#ddd"
                    st.markdown(
                        f'<div style="border: 3px solid {border_color}; padding: 5px; border-radius: 5px;">'
                        f'<p style="text-align: center; margin: 0;">第 {page_idx + 1} 页</p></div>',
                        unsafe_allow_html=True
                    )
                    st.image(img_bytes, use_container_width=True)
    
    doc.close()
    
    # 拆分功能
    st.divider()
    if start_page > end_page:
        st.error("起始页不能大于结束页")
    elif st.button("拆分 PDF", type="primary"):
        pdf_writer = PdfWriter()
        
        for page_num in range(start_page - 1, end_page):
            pdf_writer.add_page(pdf_reader.pages[page_num])
        
        output = io.BytesIO()
        pdf_writer.write(output)
        output.seek(0)
        
        st.success(f"成功拆分第 {start_page} 到 {end_page} 页")
        st.download_button(
            label="下载拆分后的 PDF",
            data=output,
            file_name=f"split_{start_page}-{end_page}.pdf",
            mime="application/pdf"
        )
