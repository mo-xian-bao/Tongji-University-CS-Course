fn program_9_1() {
    let a:(i32,i32);
    let b:();
    let c:(i32,);
}

fn program_9_2(mut a:(i32,i32)) {
    a = (1,2);
}

fn program_9_3(mut a:(i32,i32)) {
    let mut b:i32 = a.0;
    a.0 = 1;
}

