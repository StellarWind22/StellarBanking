Scriptname _SB_Quest extends Quest

;Regular account stuff
MiscObject Property Gold Auto
MiscObject Property GoldIngot Auto
GlobalVariable Property BankAccount Auto
Message Property BalanceMessage Auto
ObjectReference Property DepositBox Auto

;Loans
GlobalVariable Property LoanAccount Auto
GlobalVariable Property LoanInterestRate Auto
GlobalVariable Property LoanPayment Auto
GlobalVariable Property LoanTotal Auto
GlobalVariable Property LoanPaymentPercentage Auto
Message Property LoanMessage Auto

;Account
    ;Balance
function viewBalance(GlobalVariable account)
    BalanceMessage.Show(account.GetValueInt())
endFunction

    ;Deposit
function deposit(int amount)
    Game.GetPlayer().RemoveItem(Gold, amount)
    BankAccount.SetValueInt(BankAccount.GetValueInt() + amount)
endFunction

    ;Withdraw
function withdraw(int amount)
    Game.GetPlayer().AddItem(Gold, amount)
    BankAccount.SetValueInt(BankAccount.GetValueInt() - amount)
endFunction

    ;Exchange
function exchangeGold()
    int amount = Game.GetPlayer().GetItemCount(GoldIngot)
    Game.GetPlayer().AddItem(Gold, amount * GoldIngot.GetGoldValue())
    Game.GetPlayer().RemoveItem(GoldIngot, amount)
endFunction

    ;Safety Deposit
function openDepositBox()
    DepositBox.Activate(Game.GetPlayer())
endFunction

;Loan
    ;CalcPaymentAmount
function CalcPaymentAmount()
    int payment = (LoanTotal.GetValueInt() * LoanPaymentPercentage.GetValue()) as int

    if(payment > LoanAccount.GetValueInt()) ;Special payment size needed.
        LoanPayment.SetValueInt(LoanAccount.GetValueInt())
    else
        LoanPayment.SetValueInt(payment)
    endif
endFunction

    ;Take out
function takeOutLoan(int amount)
    LoanTotal.SetValueInt(amount + (amount * LoanInterestRate.GetValue()) as int)
    LoanAccount.SetValueInt(LoanTotal.GetValueInt())
    LoanPayment.SetValueInt((LoanTotal.GetValueInt() * LoanPaymentPercentage.GetValue()) as int)
    Game.GetPlayer().AddItem(Gold, amount)
endFunction

    ;Payment regular player
function paymentRegularPlayer()
    Game.GetPlayer().RemoveItem(Gold, LoanPayment.GetValueInt())
    LoanAccount.SetValue(LoanAccount.GetValueInt() - LoanPayment.GetValueInt())
    LoanMessage.Show(LoanPayment.GetValueInt(), LoanAccount.GetValueInt())
    CalcPaymentAmount()
endFunction

    ;Payment all player
function paymentAllPlayer()
    Game.GetPlayer().RemoveItem(Gold, LoanAccount.GetValueInt())
    LoanMessage.Show(LoanAccount.GetValueInt(), 0)
    LoanAccount.SetValueInt(0)
    CalcPaymentAmount()
endFunction

    ;Payment regular bank
function paymentRegularBank()
    BankAccount.SetValueInt(BankAccount.GetValueInt() - LoanPayment.GetValueInt())
    LoanAccount.SetValue(LoanAccount.GetValueInt() - LoanPayment.GetValueInt())
    LoanMessage.Show(LoanPayment.GetValueInt(), LoanAccount.GetValueInt())
    CalcPaymentAmount()
endFunction

    ;Payment all bank
function paymentAllBank()
    BankAccount.SetValueInt(BankAccount.GetValueInt() -  LoanAccount.GetValueInt())
    LoanMessage.Show(LoanAccount.GetValueInt(), 0)
    LoanAccount.SetValueInt(0)
    CalcPaymentAmount()
endFunction 