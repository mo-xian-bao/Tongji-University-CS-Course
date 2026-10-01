fn program_6_2(a:i32) {
    let b:& i32 = &a;
}

fn program_6_3(mut a:i32) {
    let mut b:&mut i32 = &mut a;
}

fn program_6_4(a:&mut i32) {
    let b = *a;
    *a = 3;
}

