table 50204 PostedLoanHeader_ZH
{
    Caption = 'Posted Loan Header';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; Employee; Code[20])
        {
            Caption = 'Employee';
        }
        field(3; LoanDate; Date)
        {
            Caption = 'Loan Date';
        }
        field(4; "Expected Return Date"; Date)
        {
            Caption = 'Expected Return Date';
        }
        field(5; Status; Enum LoanHeaderStatus_ZH)
        {
            Caption = 'Status';
        }
        field(6; "Actual Return Date"; Date)
        {
            Caption = 'Actual Return Date';
        }
        field(8; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
        }
        field(29; "Shortcut Dimension 1 code"; Code[20])
        {
            CaptionClass ='1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
        }
        field(30; "Shortcut Dimension 2 code"; Code[20])
        {
            CaptionClass ='1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}
