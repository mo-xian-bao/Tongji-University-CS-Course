fn add(mut a:i32, mut b:i32) -> i32 {
    a + b
}

fn classify(mut value:i32) -> i32 {
    if value > 0 {
        return 1;
    } else if value < 0 {
        return 2;
    } else {
        return 0;
    }
}

fn main() -> i32 {
    let mut total:i32 = 0;
    for mut i in 0..4 {
        if i == 2 {
            continue;
        }
        total = total + i;
    }

    let mut numbers:[i32;3] = [10,20,30];
    total = total + numbers[1];

    let mut pair:(i32,i32) = (1,2);
    pair.0 = 3;

    let mut value:i32 = 4;
    let mut reference:&mut i32 = &mut value;
    *reference = 5;

    let mut countdown:i32 = 2;
    while countdown > 0 {
        countdown = countdown - 1;
    }

    let loop_value:i32 = loop {
        break 1;
    };
    let if_value:i32 = if total > 0 {
        1
    } else {
        0
    };
    let block_value:i32 = {
        let value:i32 = 2;
        value
    };

    add(
        total + pair.0 + *reference + countdown
            + classify(0) + loop_value + if_value + block_value,
        6
    )
}
#
