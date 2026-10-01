fn callee() {
}

fn callee_with_arg(mut a:i32) {
}

fn callee_ret() -> i32 {
    return 42;
}

fn test_call() {
    callee();
    callee_with_arg(1+2);
    let mut x:i32 = callee_ret();
}
