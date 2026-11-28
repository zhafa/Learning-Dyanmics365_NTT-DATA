table 50205 PostedLoanLine_ZH
{
    Caption = 'Posted Loan Line';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(3; EquipmentCode; Code[20])
        {
            Caption = 'Equipment Code';
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(5; "Condition on Loan"; Enum "EquipmentCondition_ZH")
        {
            Caption = 'Condition on Loan';
        }
    }
    keys
    {
        key(PK; "Document No.","Line No.")
        {
            Clustered = true;
        }
    }
}
