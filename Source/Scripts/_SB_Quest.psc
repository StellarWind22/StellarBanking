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
GlobalVariable Property LoanPaymentPercentage Auto

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
    ;Take out
function takeOutLoan(int amount)
    int loanTotal = amount + (amount * LoanInterestRate.GetValue()) as int
    LoanAccount.SetValueInt(loanTotal)
    LoanPayment.SetValueInt((loanTotal * LoanPaymentPercentage.GetValue()) as int)
endFunction

    ;Payment regular player
function paymentRegularPlayer()
    Game.GetPlayer().RemoveItem(Gold, LoanPayment.GetValueInt())
    LoanAccount.SetValue(LoanAccount.GetValueInt() - LoanPayment.GetValueInt())
endFunction

    ;Payment all player
function paymentAllPlayer()
    Game.GetPlayer().RemoveItem(Gold, LoanAccount.GetValueInt())
    LoanAccount.SetValueInt(0)
endFunction

    ;Payment regular bank
function paymentRegularBank()
    BankAccount.SetValueInt(BankAccount.GetValueInt() - LoanPayment.GetValueInt())
    LoanAccount.SetValue(LoanAccount.GetValueInt() - LoanPayment.GetValueInt())
endFunction

    ;Payment all bank
function paymentAllBank()
    BankAccount.SetValueInt(BankAccount.GetValueInt() -  LoanAccount.GetValueInt())
    LoanAccount.SetValueInt(0)
endFunction 