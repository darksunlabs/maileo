program mail_nm03.aleo;

struct MailBlock:
    add as address;
    sno as u64;

record algos:
    owner as address.private;
    a1 as u32.private;
    a2 as u32.private;
    a3 as u32.private;
    k as field.private;
    hash as field.private;


mapping sent:
	key as MailBlock.public;
	value as field.public;


mapping received:
	key as MailBlock.public;
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


function send_mail:
    input r0 as address.private;
    input r1 as field.private;
    input r2 as field.private;
    input r3 as u64.private;
    rem r3 3u64 into r4;
    div r3 10u64 into r5;
    rem r5 3u64 into r6;
    div r3 100u64 into r7;
    rem r7 3u64 into r8;
    cast r4 into r9 as u32;
    cast r6 into r10 as u32;
    cast r8 into r11 as u32;
    cast r0 r9 r10 r11 r2 r1 into r12 as algos.record;
    cast r4 into r13 as u32;
    cast r6 into r14 as u32;
    cast r8 into r15 as u32;
    cast self.caller r13 r14 r15 r2 r1 into r16 as algos.record;
    async send_mail r0 self.caller r1 r3 into r17;
    output r12 as algos.record;
    output r16 as algos.record;
    output r17 as mail_nm03.aleo/send_mail.future;

finalize send_mail:
    input r0 as address.public;
    input r1 as address.public;
    input r2 as field.public;
    input r3 as u64.public;
    get.or_use timestamps[r2] 0_u64 into r4;
    is.eq r4 0_u64 into r5;
    assert.eq r5 true;
    get.or_use received_count[r0] 0u64 into r6;
    add r6 1_u64 into r7;
    get.or_use sent_count[r1] 0u64 into r8;
    add r8 1_u64 into r9;
    cast r0 r7 into r10 as MailBlock;
    set r2 into received[r10];
    cast r1 r9 into r11 as MailBlock;
    set r2 into sent[r11];
    set r3 into timestamps[r2];
    set r9 into sent_count[r1];
    set r7 into received_count[r0];

