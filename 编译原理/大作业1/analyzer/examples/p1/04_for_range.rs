fn program_5_2(mut n:i32) {
    for mut i in 1..n + 1 {
        n = n - 1;
    }

    for j:i32 in 0..3 {
        n = n + j;
    }
}

