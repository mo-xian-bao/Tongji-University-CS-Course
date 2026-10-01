/****************************************************************************
** Meta object code from reading C++ file 'Josephus.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.9.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../Josephus.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'Josephus.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 69
#error "This file was generated using the moc from 6.9.2. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

#ifndef Q_CONSTINIT
#define Q_CONSTINIT
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
QT_WARNING_DISABLE_GCC("-Wuseless-cast")
namespace {
struct qt_meta_tag_ZN4GameE_t {};
} // unnamed namespace

template <> constexpr inline auto Game::qt_create_metaobjectdata<qt_meta_tag_ZN4GameE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "Game",
        "gameStarted",
        "",
        "playerEliminated",
        "playerNumber",
        "diceRoll",
        "nextPlayerNumber",
        "gameOver",
        "winnerNumber",
        "std::vector<int>",
        "eliminationOrder",
        "eliminationPath",
        "path",
        "eliminatedPlayer"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'gameStarted'
        QtMocHelpers::SignalData<void()>(1, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'playerEliminated'
        QtMocHelpers::SignalData<void(int, int, int)>(3, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 4 }, { QMetaType::Int, 5 }, { QMetaType::Int, 6 },
        }}),
        // Signal 'gameOver'
        QtMocHelpers::SignalData<void(int, const std::vector<int> &)>(7, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 8 }, { 0x80000000 | 9, 10 },
        }}),
        // Signal 'eliminationPath'
        QtMocHelpers::SignalData<void(const std::vector<int> &, int)>(11, 2, QMC::AccessPublic, QMetaType::Void, {{
            { 0x80000000 | 9, 12 }, { QMetaType::Int, 13 },
        }}),
    };
    QtMocHelpers::UintData qt_properties {
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<Game, qt_meta_tag_ZN4GameE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject Game::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN4GameE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN4GameE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN4GameE_t>.metaTypes,
    nullptr
} };

void Game::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<Game *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->gameStarted(); break;
        case 1: _t->playerEliminated((*reinterpret_cast< std::add_pointer_t<int>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[2])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[3]))); break;
        case 2: _t->gameOver((*reinterpret_cast< std::add_pointer_t<int>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<std::vector<int>>>(_a[2]))); break;
        case 3: _t->eliminationPath((*reinterpret_cast< std::add_pointer_t<std::vector<int>>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[2]))); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (Game::*)()>(_a, &Game::gameStarted, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (Game::*)(int , int , int )>(_a, &Game::playerEliminated, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (Game::*)(int , const std::vector<int> & )>(_a, &Game::gameOver, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (Game::*)(const std::vector<int> & , int )>(_a, &Game::eliminationPath, 3))
            return;
    }
}

const QMetaObject *Game::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *Game::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN4GameE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int Game::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 4)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 4;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 4)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 4;
    }
    return _id;
}

// SIGNAL 0
void Game::gameStarted()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void Game::playerEliminated(int _t1, int _t2, int _t3)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 1, nullptr, _t1, _t2, _t3);
}

// SIGNAL 2
void Game::gameOver(int _t1, const std::vector<int> & _t2)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 2, nullptr, _t1, _t2);
}

// SIGNAL 3
void Game::eliminationPath(const std::vector<int> & _t1, int _t2)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 3, nullptr, _t1, _t2);
}
QT_WARNING_POP
