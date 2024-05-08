// The 'maileo' program.
program mail_nm03.aleo {
    struct MailBlock {
        add: address,
        sno: u64,

    }

    struct Algos {
        a1: u32,
        a2: u32,
        a3: u32,
    }

   

    mapping sent: MailBlock => field;
    mapping received: MailBlock => field;
    mapping sent_count: address => u64;
    mapping received_count: address => u64;
    mapping timestamps: field => u64;
    mapping algos: field => Algos;
    mapping masks: field => field;


    

   

    transition send_mail(to: address, hash: field, phrase: field, now: u64) -> bool {
        let from: address = self.caller;

        return true then finalize(to, from, hash, phrase, now);
    }

    finalize send_mail(to: address, from: address, hash: field, phrase: field, now: u64) {
        assert(Mapping::get_or_use(timestamps, hash, 0_u64) == 0_u64);
        
        let rec_no: u64 = Mapping::get_or_use(received_count, to, 0u64) + 1_u64;
        let sent_no: u64 = Mapping::get_or_use(sent_count, from, 0u64) + 1_u64;
        let rec_obj: MailBlock = MailBlock{add: to, sno: rec_no};
        Mapping::set(received, rec_obj, hash);
        let snt_obj: MailBlock = MailBlock{add: from, sno: sent_no};
        Mapping::set(sent, snt_obj, hash);
        Mapping::set(timestamps, hash, now);
        
        Mapping::set(sent_count, from, sent_no);
        Mapping::set(received_count, to, rec_no);

        let gen: u32 = ChaCha::rand_u32();
        let gen2: u32 = phrase as u32;
        let a: u32 = gen % 3_u32;
        let b: u32 = (gen/10_u32) % 3_u32;
        let c: u32 = (gen2) % 3_u32;
        let mask: field = (gen as field).square_root() + (gen2 as field).square_root();
        let algo_list: Algos = Algos{a1: a, a2: b, a3: c};
        Mapping::set(algos, hash, algo_list);
        Mapping::set(masks, hash, mask);


    }

    
}
