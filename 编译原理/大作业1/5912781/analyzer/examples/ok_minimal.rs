fn program(mut a:i32) -> i32 {
    let mut b:i32;
    b = a + 1;

    if b > 10 {
        return b;
    }

    while b < 10 {
        b = b + 1;
    }

    return b;
}
