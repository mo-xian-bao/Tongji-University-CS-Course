fn program_5_1(mut n:i32) {
    while n>0 {
        n=n-1;
    }
}

fn program_5_2(mut n:i32) {
    for mut i in 1..n+1 {
        n=n-1;
    }
}

fn program_5_3() {
    loop {
        break;
    }
}

fn program_5_4_break() {
    while 1==1 {
        break;
    }
}

fn program_5_4_continue() {
    while 1==0 {
        continue;
    }
}
