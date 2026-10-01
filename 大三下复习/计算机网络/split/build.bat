@echo off
echo 打包中（排除不必要的依赖）...
pyinstaller --onefile --windowed --name "PDF拆分工具" ^
    --exclude-module numpy ^
    --exclude-module pandas ^
    --exclude-module scipy ^
    --exclude-module matplotlib ^
    --exclude-module pytest ^
    --exclude-module lxml ^
    --exclude-module pyarrow ^
    --exclude-module fsspec ^
    --exclude-module pygments ^
    --exclude-module pytz ^
    --exclude-module lz4 ^
    pdf_splitter_tk.py

echo 完成！exe 在 dist 文件夹
pause
