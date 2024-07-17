program mail_nm03.aleo {
    
   struct MailBlock {
        add: address,
        sno: u64,

    }

    record algos {
        owner: address,
        a1: u32,
        a2: u32,
        a3: u32,
        key: field,
        hash: field,
    }

   

    mapping sent: MailBlock => field;
    mapping received: MailBlock => field;
    mapping sent_count: address => u64;
    mapping received_count: address => u64;
    mapping timestamps: field => u64;


    

   

    async transition send_mail(to: address, hash: field, phrase: field, now: u64) -> (algos, algos, Future) {
        let from: address = self.caller;
        let a: u64 = now % 3u64;
        let b: u64 = (now/10u64) % 3u64;
        let c: u64 = (now/100u64) % 3u64;
        let new: algos = algos {
            owner: to,
            a1: a as u32,
            a2: b as u32, 
            a3: c as u32,
            key: phrase,
            hash: hash,
        };
        let new2: algos = algos {
            owner: from,
            a1: a as u32,
            a2: b as u32, 
            a3: c as u32,
            key: phrase,
            hash: hash,
        };

        return (new, new2, send_mail_final(to, from, hash, now));
    }

    async function send_mail_final(to: address, from: address, hash: field, now: u64) {
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

        


        }
    
}


