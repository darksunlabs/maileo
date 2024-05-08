program mail_nm02.aleo;

struct Mailer:
    add as address;
    sno as u64;

struct Algos:
    a1 as u32;
    a2 as u32;
    a3 as u32;


mapping sent:
	key as Mailer.public;
	value as field.public;


mapping received:
	key as Mailer.public;
	value as field.public;


mapping sent_count:
	key as address.public;
	value as u64.public;


mapping received_count:
	key as address.public;
	value as u64.public;


mapping timestamps:
	key as field.public;
	value as u64.public;


mapping algos:
	key as field.public;
	value as Algos.public;


mapping masks:
	key as field.public;
	value as field.public;

function send_mail:
    input r0 as address.private;
    input r1 as field.private;
    input r2 as field.private;
    input r3 as u64.private;
    async send_mail r0 self.caller r1 r2 r3 into r4;
    output true as boolean.private;
    output r4 as mail_nm02.aleo/send_mail.future;

finalize send_mail:
    input r0 as address.public;
    input r1 as address.public;
    input r2 as field.public;
    input r3 as field.public;
    input r4 as u64.public;
    get.or_use timestamps[r2] 0_u64 into r5;
    is.eq r5 0_u64 into r6;
    assert.eq r6 true;
    get.or_use received_count[r0] 0u64 into r7;
    add r7 1_u64 into r8;
    get.or_use sent_count[r1] 0u64 into r9;
    add r9 1_u64 into r10;
    cast r0 r8 into r11 as Mailer;
    set r2 into received[r11];
    cast r1 r10 into r12 as Mailer;
    set r2 into sent[r12];
    set r4 into timestamps[r2];
    set r10 into sent_count[r1];
    set r8 into received_count[r0];
    rand.chacha into r13 as u32;
    cast r3 into r14 as u32;
    rem r13 3_u32 into r15;
    div r13 10_u32 into r16;
    rem r16 3_u32 into r17;
    rem r14 3_u32 into r18;
    cast r13 into r19 as field;
    sqrt r19 into r20;
    cast r14 into r21 as field;
    sqrt r21 into r22;
    add r20 r22 into r23;
    cast r15 r17 r18 into r24 as Algos;
    set r24 into algos[r2];
    set r23 into masks[r2];
