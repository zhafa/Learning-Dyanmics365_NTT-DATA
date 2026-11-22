enum 50202 LoanHeaderStatus_ZH
{
    Caption = 'Loan Header Status';
    Extensible = true;

    value(0; "Open")
    {
        Caption = 'Open';
    }

    value(1; "Released")
    {
        Caption = 'Released';
    }

    value(2; "Returned")
    {
        Caption = 'Returned';
    }
}