test_args_analyse_tools --help >res.txt
test_args_analyse_tools --intdef 12.3 >>res.txt
test_args_analyse_tools --intdef .123 --intdef 456 >>res.txt
test_args_analyse_tools --intdef -12. >>res.txt
test_args_analyse_tools --intsetdef 1-1 --intsetdef 22 >>res.txt
test_args_analyse_tools --intseterr 11- >>res.txt
test_args_analyse_tools --intseterr 12 >>res.txt
test_args_analyse_tools --intseterr --intseterr 22 >>res.txt
test_args_analyse_tools --doubledef -2.34 >>res.txt
test_args_analyse_tools --doubledef 2-.34 --doubledef 4.32. >>res.txt
test_args_analyse_tools --doubledef -.3 >>res.txt
test_args_analyse_tools --doubledef >>res.txt
test_args_analyse_tools --doubleerr -- >>res.txt
test_args_analyse_tools --doublesetdef - >>res.txt
test_args_analyse_tools --doubleseterr 12.3 >>res.txt
test_args_analyse_tools --str1 "hello" >>res.txt
test_args_analyse_tools --strsetdef md5 >>res.txt
test_args_analyse_tools --ipdef 00000000.000000.000000000.00 >>res.txt
test_args_analyse_tools --iperr 1.1.1.1 >>res.txt


test_args_analyse_tools-demo --help >res-demo.txt
test_args_analyse_tools-demo --intdef 12.3 >>res-demo.txt  
test_args_analyse_tools-demo --intdef .123 --intdef 456 >>res-demo.txt  
test_args_analyse_tools-demo --intdef -12. >>res-demo.txt  
test_args_analyse_tools-demo --intsetdef 1-1 --intsetdef 22 >>res-demo.txt  
test_args_analyse_tools-demo --intseterr 11- >>res-demo.txt  
test_args_analyse_tools-demo --intseterr 12 >>res-demo.txt  
test_args_analyse_tools-demo --intseterr --intseterr 22 >>res-demo.txt  
test_args_analyse_tools-demo --doubledef -2.34 >>res-demo.txt  
test_args_analyse_tools-demo --doubledef 2-.34 --doubledef 4.32. >>res-demo.txt  
test_args_analyse_tools-demo --doubledef -.3 >>res-demo.txt  
test_args_analyse_tools-demo --doubledef >>res-demo.txt  
test_args_analyse_tools-demo --doubleerr -- >>res-demo.txt  
test_args_analyse_tools-demo --doublesetdef - >>res-demo.txt  
test_args_analyse_tools-demo --doubleseterr 12.3 >>res-demo.txt  
test_args_analyse_tools-demo --str1 "hello" >>res-demo.txt  
test_args_analyse_tools-demo --strsetdef md5 >>res-demo.txt  
test_args_analyse_tools-demo --ipdef 00000000.000000.000000000.00 >>res-demo.txt  
test_args_analyse_tools-demo --iperr 1.1.1.1 >>res-demo.txt

compare --file1 res.txt --file2 res-demo.txt --trim right --display normal >com-res.txt