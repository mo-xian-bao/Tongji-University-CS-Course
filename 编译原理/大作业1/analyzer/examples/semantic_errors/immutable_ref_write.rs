fn bad_ref(mut a:i32) {
    let b:& i32 = &a;
    *b = 3;
}

