table 50201 EquipmentSetup_ZH
{
    Caption = 'Equipment Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Equipment Nos."; Code[20])
        {
            Caption = 'Equipment Nos.';
            TableRelation = "No. Series";
        }
        field(3; "Loan Nos."; Code[20])
        {
            Caption = 'Loan Nos.';
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure GetSetup()
    begin
        if not Rec.Get() then begin
            Init();
            Insert();
        end;
    end;
}