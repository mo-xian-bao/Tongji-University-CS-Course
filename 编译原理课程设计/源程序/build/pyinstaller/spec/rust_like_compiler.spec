# -*- mode: python ; coding: utf-8 -*-


a = Analysis(
    ['D:\\desktop\\编译原理课程设计\\analyzer\\gui.py'],
    pathex=[],
    binaries=[],
    datas=[('D:\\desktop\\编译原理课程设计\\analyzer\\assets', 'assets'), ('D:\\desktop\\编译原理课程设计\\analyzer\\examples\\course_full.rs', 'examples'), ('D:\\desktop\\编译原理课程设计\\analyzer\\examples\\err_lex.rs', 'examples'), ('D:\\desktop\\编译原理课程设计\\analyzer\\examples\\err_parse.rs', 'examples'), ('D:\\desktop\\编译原理课程设计\\analyzer\\examples\\extra\\test_2.rs', 'examples/extra'), ('D:\\desktop\\编译原理课程设计\\analyzer\\examples\\minimum\\test_0.rs', 'examples/minimum'), ('D:\\desktop\\编译原理课程设计\\analyzer\\examples\\minimum\\test_1.rs', 'examples/minimum'), ('D:\\desktop\\编译原理课程设计\\analyzer\\examples\\minimum\\test_1_error.rs', 'examples/minimum'), ('D:\\desktop\\编译原理课程设计\\analyzer\\examples\\minimum\\test_2.rs', 'examples/minimum'), ('D:\\desktop\\编译原理课程设计\\analyzer\\examples\\minimum\\test_2_error.rs', 'examples/minimum'), ('D:\\desktop\\编译原理课程设计\\analyzer\\examples\\minimum\\test_3.rs', 'examples/minimum'), ('D:\\desktop\\编译原理课程设计\\analyzer\\examples\\minimum\\test_4.rs', 'examples/minimum'), ('D:\\desktop\\编译原理课程设计\\analyzer\\examples\\minimum\\test_5.rs', 'examples/minimum'), ('D:\\desktop\\编译原理课程设计\\analyzer\\examples\\minimum\\test_call.rs', 'examples/minimum'), ('D:\\desktop\\编译原理课程设计\\analyzer\\examples\\ok_minimal.rs', 'examples'), ('D:\\desktop\\编译原理课程设计\\analyzer\\examples\\v1_ir.rs', 'examples'), ('D:\\desktop\\编译原理课程设计\\analyzer\\examples\\v2_compare.rs', 'examples')],
    hiddenimports=[],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name='rust_like_compiler',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=False,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    version='D:\\desktop\\编译原理课程设计\\analyzer\\assets\\version_info.txt',
    icon=['D:\\desktop\\编译原理课程设计\\analyzer\\assets\\compiler.ico'],
)
