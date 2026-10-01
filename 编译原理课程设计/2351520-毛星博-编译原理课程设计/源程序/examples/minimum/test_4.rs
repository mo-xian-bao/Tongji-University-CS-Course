fn program_4_1(mut a:i32) -> i32 {
    if a>0 {
        return 1;
    }
    return 0;
}

fn program_4_2(mut a:i32) -> i32 {
    if a>0 {
        return 1;
    } else {
        return 0;
    }
}

fn program_4_3(mut a:i32) -> i32 {
    if a>0 {
        return a+1;
    } else if a<0 {
        return a-1;
    } else {
        return 0;
    }
}
