Scriptname _SB_PlayerScript extends ReferenceAlias  

;Main
GlobalVariable Property HourInterval Auto

;Interest
GlobalVariable Property BankAccount Auto
GlobalVariable Property AccountInterestRate Auto
Message Property InterestMessage Auto

;Investment
GlobalVariable Property InvestmentProfit Auto
Message Property InvestmentMessage Auto

;Loan
GlobalVariable Property LoanAccount Auto
GlobalVariable Property LoanPayment Auto
GlobalVariable Property LoanInterestRate Auto
Message Property LoanMessage Auto
Message Property LoanFailMessage Auto

event OnInit()
    RegisterForSingleUpdateGameTime(HourInterval.GetValueInt())
endEvent

event OnPlayerLoadGame()
    RegisterForSingleUpdateGameTime(HourInterval.GetValueInt())
endEvent

event OnUpdateGameTime()

    ;Handle interest(if they have money)
    if(BankAccount.GetValueInt() > 0)
        int accountInterest = (BankAccount.GetValueInt() * AccountInterestRate.GetValue()) as int   ;Calc interest
        BankAccount.SetValueInt(BankAccount.GetValueInt() + accountInterest)                        ;Add interest to bank account
        InterestMessage.Show(accountInterest)                                                       ;Tell player about this
    endIf

    ;Handle investments(If they have any)
    int investments = Game.QueryStat("Stores Invested In")
    if(investments > 0)
        int profit = investments * InvestmentProfit.GetValueInt()                                   ;Calc profit
        BankAccount.SetValueInt(BankAccount.GetValueInt() + profit)                                 ;Add profit to bank account
        InvestmentMessage.Show(profit)                                                              ;Tell player about this
    endIf

    ;Handle loan(if they have one)
    if(LoanAccount.GetValueInt() > 0)
        int payment = 0;

        ;If loan payment is bigger than remaining total(special last payment size needed)
        if(LoanPayment.GetValueInt() > LoanAccount.GetValueInt())
            payment = LoanAccount.GetValueInt()                                                     ;Set value to remaining(for wierd percentages)
        ;else
        else
           payment = LoanPayment.GetValueInt()                                                      ;Set value to standard payment
        endIf

        ;If can pay
        if(payment <= BankAccount.GetValueInt())
            BankAccount.SetValueInt(BankAccount.GetValueInt() - payment)                            ;Subtract from bank
            LoanAccount.SetValueInt(LoanAccount.GetValueInt() - payment)                            ;Subtract from loan total
            LoanMessage.Show(payment, LoanAccount.GetValueInt())                                    ;Tell player about this
        ;If not
        else
            LoanFailMessage.Show(payment)                                                           ;Tell player payment failed.
        endIf
    endIf

    ;Re-register
    RegisterForSingleUpdateGameTime(HourInterval.GetValueInt())
endEvent