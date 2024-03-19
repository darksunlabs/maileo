program helloworld_nm01.aleo;



function main:
    input r0 as u32.public;
    input r1 as u32.private;
    input r2 as u32.private;
    is.neq r2 0_u32 into r3;
    assert.eq r3 true;
    is.eq r2 1_u32 into r4;
    sub r2 1_u32 into r5;
    mul r5 r1 into r6;
    add r0 r6 into r7;
    ternary r4 r0 r7 into r8;
    output r8 as u32.private;
