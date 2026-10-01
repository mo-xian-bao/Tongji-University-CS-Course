15-b6 --check test_1.log >res.txt
15-b6 --check test_2.py >>res.txt
15-b6 --check test_3.png >>res.txt
15-b6 --check test_4.gif >>res.txt
15-b6 --check test_5.pptx >>res.txt
15-b6 --check test_6.exe >>res.txt
15-b6 --check test_7.docx >>res.txt

15-b6-demo --check test_1.log >res-demo.txt
15-b6-demo --check test_2.py >>res-demo.txt
15-b6-demo --check test_3.png >>res-demo.txt
15-b6-demo --check test_4.gif >>res-demo.txt
15-b6-demo --check test_5.pptx >>res-demo.txt
15-b6-demo --check test_6.exe >>res-demo.txt
15-b6-demo --check test_7.docx >>res-demo.txt

15-b6 --convert wtol test_1.log res1.txt >>res.txt
15-b6 --convert ltow test_2.py res2.txt >>res.txt
15-b6 --convert ltow test_6.exe res3.txt >>res.txt

15-b6-demo --convert wtol test_1.log res1-demo.txt >>res-demo.txt
15-b6-demo --convert ltow test_2.py res2-demo.txt >>res-demo.txt
15-b6-demo --convert ltow test_6.exe res3-demo.txt >>res-demo.txt

compare --file1 res.txt --file2 res-demo.txt --display normal >final-res.txt 
