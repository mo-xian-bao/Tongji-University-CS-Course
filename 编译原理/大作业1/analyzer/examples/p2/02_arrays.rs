fn program_8_1() {
    let mut a:[i32;3];
}

fn program_8_2(mut a:[i32;3]) {
    a = [1,2,3];
}

fn program_8_3(mut a:[i32;3]) {
    let mut b:i32 = a[0];
    a[0] = 1;
}

fn program_8_iterable() {
    for mut i in [1,2,3] {
        i;
    }
}

