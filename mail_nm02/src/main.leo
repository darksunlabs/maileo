// The 'helloworld' program.
program mail_nm02.aleo {
    struct Mailer {
        add: address,
        sno: u64,

    }

    record Cyphers {
        owner: address,
        mask: field,
        algo1: u8,
        algo2: u8,
        algo3: u8,
    }

   
    
    mapping sent: Mailer => field;
    mapping received: Mailer => field;
    mapping sent_count: address => u64;
    mapping received_count: address => u64;
    mapping timestamps: field => u64;
    

    transition initialize_account(nonce: u32) -> bool{
        let owner: address = self.caller;
        return true then finalize(owner, nonce);
    }

    finalize initialize_account(owner: address, nonce: u32) {
        let gen: u32 = ChaCha::rand_u32();
        let gen2: u32 = gen + nonce;
        let a1: u32 = gen % 3_u32;
        let a2: u32 = (gen/10_u32) % 3_u32;
        let a3: u32 = (gen2) % 3_u32;
        let msk: field = (gen as field).square_root() + (gen2 as field).square_root();
        let cyph: Cyphers = Cyphers {owner: owner, mask: msk, algo1: a1 as u8, algo2: a2 as u8, algo3: a3 as u8};

    }

    transition send_mail(to: address, hash: field, nonce: u32, now: u64) -> bool {
        let from: address = self.caller;

        return true then finalize(to, from, hash, nonce, now);
    }

    finalize send_mail(to: address, from: address, hash: field, nonce: u32, now: u64) {
        assert(Mapping::get_or_use(timestamps, hash, 0_u64) == 0_u64);
        
        let rec_no: u64 = Mapping::get_or_use(received_count, to, 0u64) + 1_u64;
        let sent_no: u64 = Mapping::get_or_use(sent_count, from, 0u64) + 1_u64;
        let rec_obj: Mailer = Mailer{add: to, sno: rec_no};
        Mapping::set(received, rec_obj, hash);
        let snt_obj: Mailer = Mailer{add: from, sno: sent_no};
        Mapping::set(sent, snt_obj, hash);
        Mapping::set(timestamps, hash, now);
        
        Mapping::set(sent_count, from, sent_no);
        Mapping::set(received_count, to, rec_no);


    }

    
}
