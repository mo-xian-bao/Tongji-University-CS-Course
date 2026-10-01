test_args_analyse_tools --help >res.txt
test_args_analyse_tools --bool >>res.txt
test_args_analyse_tools --intdef 123 >>res.txt
test_args_analyse_tools --intdef 123 --intdef 456 >>res.txt
test_args_analyse_tools --intdef -12 >>res.txt
test_args_analyse_tools --intdef 654321 >>res.txt
test_args_analyse_tools --interr 123 >>res.txt
test_args_analyse_tools --interr 123 --interr 456 >>res.txt
test_args_analyse_tools --interr -12 >>res.txt
test_args_analyse_tools --interr 654321 >>res.txt
test_args_analyse_tools --intsetdef 11 >>res.txt
test_args_analyse_tools --intsetdef 12 >>res.txt
test_args_analyse_tools --intsetdef 11 --intsetdef 22 >>res.txt
test_args_analyse_tools --intseterr 11 >>res.txt
test_args_analyse_tools --intseterr 12 >>res.txt
test_args_analyse_tools --intseterr 11 --intseterr 22 >>res.txt
test_args_analyse_tools --doubledef 2.34 >>res.txt
test_args_analyse_tools --doubledef 2.34 --doubledef 4.32 >>res.txt
test_args_analyse_tools --doubledef -3 >>res.txt
test_args_analyse_tools --doubledef 101.234 >>res.txt
test_args_analyse_tools --doubleerr 2.34 >>res.txt
test_args_analyse_tools --doubleerr 2.34 --doubledef 4.32 >>res.txt
test_args_analyse_tools --doubleerr -3 >>res.txt
test_args_analyse_tools --doubleerr 101.234 >>res.txt
test_args_analyse_tools --doublesetdef 12.3 >>res.txt
test_args_analyse_tools --doublesetdef 5.6 >>res.txt
test_args_analyse_tools --doublesetdef 1.1 --doublesetdef 2.2 >>res.txt
test_args_analyse_tools --doubleseterr 12.3 >>res.txt
test_args_analyse_tools --doubleseterr 5.6 >>res.txt
test_args_analyse_tools --doubleseterr 1.1 --doubleseterr 2.2 >>res.txt
test_args_analyse_tools --str1 hello >>res.txt
test_args_analyse_tools --str1 hello --str1 horse >>res.txt
test_args_analyse_tools --str2 hello >>res.txt
test_args_analyse_tools --str2 hello --str2 horse >>res.txt
test_args_analyse_tools --strsetdef md5 >>res.txt
test_args_analyse_tools --strsetdef md4 >>res.txt
test_args_analyse_tools --strsetdef md5 --strsetdef sha1 >>res.txt
test_args_analyse_tools --strseterr md5 >>res.txt
test_args_analyse_tools --strseterr md4 >>res.txt
test_args_analyse_tools --strseterr md5 --strseterr sha1 >>res.txt
test_args_analyse_tools --ipdef 1.1.1.1 >>res.txt
test_args_analyse_tools --ipdef 1.1.1.1234 >>res.txt
test_args_analyse_tools --ipdef 1.1.1.1 --ipdef 2.2.2.2 >>res.txt
test_args_analyse_tools --iperr 1.1.1.1 >>res.txt
test_args_analyse_tools --iperr 1.1.1.1234 >>res.txt
test_args_analyse_tools --iperr 1.1.1.1 --iperr 2.2.2.2 >>res.txt

test_args_analyse_tools-demo --help >res-demo.txt
test_args_analyse_tools-demo --bool >>res-demo.txt
test_args_analyse_tools-demo --intdef 123 >>res-demo.txt
test_args_analyse_tools-demo --intdef 123 --intdef 456 >>res-demo.txt
test_args_analyse_tools-demo --intdef -12 >>res-demo.txt
test_args_analyse_tools-demo --intdef 654321 >>res-demo.txt
test_args_analyse_tools-demo --interr 123 >>res-demo.txt
test_args_analyse_tools-demo --interr 123 --interr 456 >>res-demo.txt
test_args_analyse_tools-demo --interr -12 >>res-demo.txt
test_args_analyse_tools-demo --interr 654321 >>res-demo.txt
test_args_analyse_tools-demo --intsetdef 11 >>res-demo.txt
test_args_analyse_tools-demo --intsetdef 12 >>res-demo.txt
test_args_analyse_tools-demo --intsetdef 11 --intsetdef 22 >>res-demo.txt
test_args_analyse_tools-demo --intseterr 11 >>res-demo.txt
test_args_analyse_tools-demo --intseterr 12 >>res-demo.txt
test_args_analyse_tools-demo --intseterr 11 --intseterr 22 >>res-demo.txt
test_args_analyse_tools-demo --doubledef 2.34 >>res-demo.txt
test_args_analyse_tools-demo --doubledef 2.34 --doubledef 4.32 >>res-demo.txt
test_args_analyse_tools-demo --doubledef -3 >>res-demo.txt
test_args_analyse_tools-demo --doubledef 101.234 >>res-demo.txt
test_args_analyse_tools-demo --doubleerr 2.34 >>res-demo.txt
test_args_analyse_tools-demo --doubleerr 2.34 --doubledef 4.32 >>res-demo.txt
test_args_analyse_tools-demo --doubleerr -3 >>res-demo.txt
test_args_analyse_tools-demo --doubleerr 101.234 >>res-demo.txt
test_args_analyse_tools-demo --doublesetdef 12.3 >>res-demo.txt
test_args_analyse_tools-demo --doublesetdef 5.6 >>res-demo.txt
test_args_analyse_tools-demo --doublesetdef 1.1 --doublesetdef 2.2 >>res-demo.txt
test_args_analyse_tools-demo --doubleseterr 12.3 >>res-demo.txt
test_args_analyse_tools-demo --doubleseterr 5.6 >>res-demo.txt
test_args_analyse_tools-demo --doubleseterr 1.1 --doubleseterr 2.2 >>res-demo.txt
test_args_analyse_tools-demo --str1 hello >>res-demo.txt
test_args_analyse_tools-demo --str1 hello --str1 horse >>res-demo.txt
test_args_analyse_tools-demo --str2 hello >>res-demo.txt
test_args_analyse_tools-demo --str2 hello --str2 horse >>res-demo.txt
test_args_analyse_tools-demo --strsetdef md5 >>res-demo.txt
test_args_analyse_tools-demo --strsetdef md4 >>res-demo.txt
test_args_analyse_tools-demo --strsetdef md5 --strsetdef sha1 >>res-demo.txt
test_args_analyse_tools-demo --strseterr md5 >>res-demo.txt
test_args_analyse_tools-demo --strseterr md4 >>res-demo.txt
test_args_analyse_tools-demo --strseterr md5 --strseterr sha1 >>res-demo.txt
test_args_analyse_tools-demo --ipdef 1.1.1.1 >>res-demo.txt
test_args_analyse_tools-demo --ipdef 1.1.1.1234 >>res-demo.txt
test_args_analyse_tools-demo --ipdef 1.1.1.1 --ipdef 2.2.2.2 >>res-demo.txt
test_args_analyse_tools-demo --iperr 1.1.1.1 >>res-demo.txt
test_args_analyse_tools-demo --iperr 1.1.1.1234 >>res-demo.txt
test_args_analyse_tools-demo --iperr 1.1.1.1 --iperr 2.2.2.2 >>res-demo.txt

txt_compare --file1 res.txt --file2 res-demo.txt --trim right --display normal >com-res.txt
