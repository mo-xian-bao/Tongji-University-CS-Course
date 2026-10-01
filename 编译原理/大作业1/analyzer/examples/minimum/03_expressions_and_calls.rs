fn program_3_1__1() {
    0;
    (1);
    ((2));
    (((3)));
}

fn program_3_1__2(mut a:i32) {
    a;
    (a);
    ((a));
    (((a)));
}

fn program_3_2() {
    1 < 2;
    3 > 4;
    1 <= 2;
    3 >= 2;
    1 == 1;
    1 != 2;
}

fn program_3_3() {
    1 + 2;
    3 - 4;
}

fn program_3_4() {
    1 * 2;
    3 / 4;
    1 + 2 * 3;
}

fn program_3_5__1() {
}

fn program_3_5__2() {
    program_3_5__1();
}

fn program_3_5__3(mut a:i32, mut b:i32) -> i32 {
    return a + b;
}

fn program_3_5__4() {
    program_3_5__3(1, 2);
    program_3_5__3(1 + 2, program_3_5__3(3, 4));
}

