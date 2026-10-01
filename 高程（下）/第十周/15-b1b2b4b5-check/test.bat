@echo off

echo ------part1:compare 1 with demo(15-b1 and 15-b2)------

for %%n in (1 2 3 4 5 6 7) do (
    for %%f in (test-data/test_%%n*) do "exe/15-b1-demo" --infile "test-data/%%f" --outfile "hex-data/test_%%n-demo.hex"
    for %%f in (test-data/test_%%n*) do "exe/15-b1-1" --infile "test-data/%%f" --outfile "hex-data/test_%%n-1.hex"
    "exe/15-b2-demo" --infile "hex-data/test_%%n-1.hex" --outfile "back-data/test_%%n-demo.back"
    "exe/15-b2-1" --infile "hex-data/test_%%n-demo.hex" --outfile "back-data/test_%%n-1.back"
    comp /m "back-data/test_%%n-demo.back" "back-data/test_%%n-1.back"
)

echo ------part2:compare 1 with demo(15-b1 and 15-b5)------

for %%n in (1 2 3 4 5 6 7) do (
    "exe/15-b2-demo" --infile "hex-data/test_%%n-1.hex" --outfile "back-data/test_%%n-demo.back"
    "exe/15-b5-1" --infile "hex-data/test_%%n-demo.hex" --outfile "back-data/test_%%n-1.back"
    comp /m "back-data/test_%%n-demo.back" "back-data/test_%%n-1.back"
)

echo ------part3:compare 1 with demo(15-b4 and 15-b2)------

for %%n in (1 2 3 4 5 6 7) do (
    for %%f in (test-data/test_%%n*) do "exe/15-b4-1" --infile "test-data/%%f" --outfile "hex-data/test_%%n-1.hex"
    "exe/15-b2-demo" --infile "hex-data/test_%%n-1.hex" --outfile "back-data/test_%%n-demo.back"
    "exe/15-b2-1" --infile "hex-data/test_%%n-demo.hex" --outfile "back-data/test_%%n-1.back"
    comp /m "back-data/test_%%n-demo.back" "back-data/test_%%n-1.back"
)

echo ------part4:compare 1 with demo(15-b4 and 15-b5)------

for %%n in (1 2 3 4 5 6 7) do (
    "exe/15-b2-demo" --infile "hex-data/test_%%n-1.hex" --outfile "back-data/test_%%n-demo.back"
    "exe/15-b5-1" --infile "hex-data/test_%%n-demo.hex" --outfile "back-data/test_%%n-1.back"
    comp /m "back-data/test_%%n-demo.back" "back-data/test_%%n-1.back"
)

echo ------part5:compare 2 with demo(15-b1 and 15-b2)------

for %%n in (1 2 3 4 5 6 7) do (
    for %%f in (test-data/test_%%n*) do "exe/15-b1-demo" --infile "test-data/%%f" --outfile "hex-data/test_%%n-demo.hex"
    for %%f in (test-data/test_%%n*) do "exe/15-b1-2" --infile "test-data/%%f" --outfile "hex-data/test_%%n-2.hex"
    "exe/15-b2-demo" --infile "hex-data/test_%%n-2.hex" --outfile "back-data/test_%%n-demo.back"
    "exe/15-b2-2" --infile "hex-data/test_%%n-demo.hex" --outfile "back-data/test_%%n-2.back"
    comp /m "back-data/test_%%n-demo.back" "back-data/test_%%n-2.back"
)

echo ------part6:compare 2 with demo(15-b1 and 15-b5)------

for %%n in (1 2 3 4 5 6 7) do (
    "exe/15-b2-demo" --infile "hex-data/test_%%n-2.hex" --outfile "back-data/test_%%n-demo.back"
    "exe/15-b5-2" --infile "hex-data/test_%%n-demo.hex" --outfile "back-data/test_%%n-2.back"
    comp /m "back-data/test_%%n-demo.back" "back-data/test_%%n-2.back"
)

echo ------part7:compare 2 with demo(15-b4 and 15-b2)------

for %%n in (1 2 3 4 5 6 7) do (
    for %%f in (test-data/test_%%n*) do "exe/15-b4-2" --infile "test-data/%%f" --outfile "hex-data/test_%%n-2.hex"
    "exe/15-b2-demo" --infile "hex-data/test_%%n-2.hex" --outfile "back-data/test_%%n-demo.back"
    "exe/15-b2-2" --infile "hex-data/test_%%n-demo.hex" --outfile "back-data/test_%%n-2.back"
    comp /m "back-data/test_%%n-demo.back" "back-data/test_%%n-2.back"
)

echo ------part8:compare 2 with demo(15-b4 and 15-b5)------

for %%n in (1 2 3 4 5 6 7) do (
    "exe/15-b2-demo" --infile "hex-data/test_%%n-2.hex" --outfile "back-data/test_%%n-demo.back"
    "exe/15-b5-2" --infile "hex-data/test_%%n-demo.hex" --outfile "back-data/test_%%n-2.back"
    comp /m "back-data/test_%%n-demo.back" "back-data/test_%%n-2.back"
)


echo ------part9:compare 1 with 2(15-b1 and 15-b2)------

for %%n in (1 2 3 4 5 6 7) do (
    for %%f in (test-data/test_%%n*) do "exe/15-b1-1" --infile "test-data/%%f" --outfile "hex-data/test_%%n-1.hex"
    for %%f in (test-data/test_%%n*) do "exe/15-b1-2" --infile "test-data/%%f" --outfile "hex-data/test_%%n-2.hex"
    "exe/15-b2-1" --infile "hex-data/test_%%n-2.hex" --outfile "back-data/test_%%n-1.back"
    "exe/15-b2-2" --infile "hex-data/test_%%n-1.hex" --outfile "back-data/test_%%n-2.back"
    comp /m "back-data/test_%%n-1.back" "back-data/test_%%n-2.back"
)

echo ------part10:compare 1 with 2(15-b1 and 15-b5)------

for %%n in (1 2 3 4 5 6 7) do (
    "exe/15-b5-1" --infile "hex-data/test_%%n-2.hex" --outfile "back-data/test_%%n-1.back"
    "exe/15-b5-2" --infile "hex-data/test_%%n-1.hex" --outfile "back-data/test_%%n-2.back"
    comp /m "back-data/test_%%n-1.back" "back-data/test_%%n-2.back"
)

echo ------part11:compare 1 with 2(15-b4 and 15-b2)------

for %%n in (1 2 3 4 5 6 7) do (
    for %%f in (test-data/test_%%n*) do "exe/15-b4-1" --infile "test-data/%%f" --outfile "hex-data/test_%%n-1.hex"
    for %%f in (test-data/test_%%n*) do "exe/15-b4-2" --infile "test-data/%%f" --outfile "hex-data/test_%%n-2.hex"
    "exe/15-b2-1" --infile "hex-data/test_%%n-2.hex" --outfile "back-data/test_%%n-1.back"
    "exe/15-b2-2" --infile "hex-data/test_%%n-1.hex" --outfile "back-data/test_%%n-2.back"
    comp /m "back-data/test_%%n-1.back" "back-data/test_%%n-2.back"
)

echo ------part12:compare 1 with 2(15-b4 and 15-b5)------

for %%n in (1 2 3 4 5 6 7) do (
    "exe/15-b5-1" --infile "hex-data/test_%%n-2.hex" --outfile "back-data/test_%%n-1.back"
    "exe/15-b5-2" --infile "hex-data/test_%%n-1.hex" --outfile "back-data/test_%%n-2.back"
    comp /m "back-data/test_%%n-1.back" "back-data/test_%%n-2.back"
)


PAUSE