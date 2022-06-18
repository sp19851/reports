
const App = {
    
    data() {
        return {
            show: false, 
            showreports:false,
            modalWindowShoing: false,
            modalInputShoing: false,
            modalAnswerShoing: false,
            currentitem: null,
            admin : '',
            dialog_title: 'Erf;bnt ghbxbyefsdfs sdfasefasef esdfasefaserf e ewfaser fewrfaser we ',
            inputcontent:'',
            reports:[
                {id: 1, callerid: 123, caller: "James Braun", citizenid: "WER2332", info: 'Тут у нас, кароче, собака, ну она не собака, она, пахоже читер. Ну я не знаю, она, кароче, летает и хз. Разбирайтесь', admin:"Cruso", active:true, description:""},
                {id: 2, callerid: 123423, caller: "Jassy Smith", citizenid: "QWE233S", info: 'Ну я не знаю. Я зашел, а тут оно все не так. Это точно баг.', admin:"none", active:true, description:""},
                {id: 3, callerid: 3323, caller: "sdafasdf Braun", citizenid: "###R2332", info: 'Тут у нас, кароче, собака, ну она не собака, она, пахоже читер. Ну я не знаю, она, кароче, летает и хз. Разбирайтесь', admin:"none", active:false, description:""},
            ],
           
        }
    },    
    
    components:{},
  

    methods: {
        onClose() {
            //this.show = false;
            $.post('https://reports/close');

        },
        closeT(item) {
            this.dialog_title = "Укажите причину закрытия тикета"
            this.modalWindowShoing = true
            this.currentitem = item
        },
        isAttack(item) {
            //
            if(item.admin !="none") {
                return true;
            } else {
                return false;
            }
 
        },
        attach(item) {
            if(item.admin !="none") {
                console.log('Used')
            } else 
            {
                for (let i = 0; i < this.reports.length; i += 1) {
                    if (this.reports[i].id == item.id) {
                        this.reports[i].admin = this.admin
                        $.post('https://reports/refresh', JSON.stringify({reports:this.reports, caller:item.callerid, type:"attach"}));
                        break 
                    }

                }       
            }
        },

        dettach(item) {
            if(item.admin !="none") {
                for (let i = 0; i < this.reports.length; i += 1) {
                    if (this.reports[i].id == item.id) {
                        this.reports[i].admin = "none"
                        $.post('https://reports/refresh', JSON.stringify({reports:this.reports, caller:item.callerid, type:"dettach"}));
                        break 
                    }

                }       
            }
        },

        spec(item) {
            for (let i = 0; i < this.reports.length; i += 1) {
                if (this.reports[i].id == item.id) {
                    this.reports[i].admin = this.admin
                    $.post('https://reports/spec', JSON.stringify({caller:item.callerid, type:"spec", reports:this.reports}));
                    break 
                }
            } 
        },

        reply(item) {
            for (let i = 0; i < this.reports.length; i += 1) {
                if (this.reports[i].id == item.id) {
                    this.reports[i].admin = this.admin
                    $.post('https://reports/refresh', JSON.stringify({reports:this.reports, caller:item.callerid, type:"attach"}));
                    break 
                }
            }  
            this.dialog_title = "Ваш ответ игроку"   
            this.modalWindowShoing = true
            this.currentitem = item
        },
        btnCancel(){
            //console.log('------------')
            this.ticketcontext = '';
            this.modalWindowShoing = false;
            //$.post('https://reports/cancelticket');
        },
        btnOk() {
            console.log('btnOk', this.dialog_title, this.inputcontent)
            //console.log('this.currentitem', this.currentitem.id)
            
            if (this.dialog_title === "Укажите причину закрытия тикета") {
                if (this.inputcontent == "") {
                    $.post('https://reports/notify', JSON.stringify({content:"Заполните поле ввода"}));
                    return
                }
                let id = this.currentitem.id
                for (let i = 0; i < this.reports.length; i += 1) {
                    if (this.reports[i].id == id) {
                        //console.log(id, JSON.stringify(this.reports))
                        this.reports[i].description = this.inputcontent
                        this.reports[i].active = false
                        //console.log('*')
                        //console.log('this.reports[this.currentitem.id].active', this.reports[i].active)
                        $.post('https://reports/refresh', JSON.stringify({reports:this.reports, caller:null, type:"closeT"}));
                        this.modalWindowShoing = false
                        break 
                    }
                }      
                
            }else if (this.dialog_title === "Опишите свою проблему четко и кратко") {
                //console.log(this.inputcontent)
                if (this.inputcontent == "") {
                    $.post('https://reports/notify', JSON.stringify({content:"Заполните поле ввода"}));
                    return
                }
                $.post('https://reports/new', JSON.stringify({context:this.inputcontent}));
                this.modalWindowShoing = false
                this.inputcontent = ""
                
            }else if (this.dialog_title === "Ваш ответ игроку") {
                //console.log('*r', this.inputcontent, this.currentitem)
                
                $.post('https://reports/reply', JSON.stringify({answer:this.inputcontent, ticket:this.currentitem, type:"reply"}));
                this.modalWindowShoing = false
                this.inputcontent = ""
            }
           
        },
        submit(){
            console.log('ticketcontext', this.ticketcontext)
            if(this.ticketcontext != "") {
                $.post('https://reports/new', JSON.stringify({context:this.ticketcontext}));
                this.ticketcontext = '';
                this.modalInputShoing = false;
            }
        },
        

      
      
},
    
    mounted() {
        this.listener = window.addEventListener("message", (event) => {
            //console.log('test window.addEventListener', event.data.action)
            if(event.data.action === 'open') {
                //console.log(JSON.stringify(event.data))
                this.reports = event.data.reports 
                this.admin =  event.data.admin 
                this.showreports = true
                this.show = true
                this.modalInputShoing = false
                //this.alerts = event.data.alerts;
                /*for (let i = 0; i < event.data.alerts.length; i += 1) {
                    let Item = event.data.alerts[i]
                    //console.log(i, Item.description, Item.attached)
                    for (let j = 0; j < Item.attached.length; j += 1) {
                        let Item2 = Item.attached[j]
                        console.log(j, Item2, Item2.cs, Item2.id_at)
                        console.log(JSON.stringify(Item2))
                        for (let y = 0; y < Item2.length; y += 1) {
                            console.log(y, Item2[y])
                        }
                        
                    }
                }*/
                //this.myCallsign = event.data.myCallsign;
                //this.myType = event.data.type;
                //this.filteredTypes();
                //console.log('myCallsign', this.myCallsign)
                //this.showingForm(true);

            } else if(event.data.action === 'close') {
                this.onClose()
            } else if(event.data.action === 'newreport') {
                this.dialog_title = "Опишите свою проблему четко и кратко"
                this.showreports = false
                this.modalWindowShoing = true
                this.show = true
            } else if(event.data.action === 'refresh') {
                this.reports = event.data.reports 

            }
            
        });
        window.document.onkeydown = event => event && event.code === 'Escape' ? this.onClose() : null
       

        
       

      },
    create: {
        

    },
    watch: {
       
    },

    computed: {
      
    }
}




let app = Vue.createApp(App)
app.mount('#app')

//v-if="item.attached.lenght>0"