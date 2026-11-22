table 50203 LoanLine_ZH
{
    Caption = 'Loan Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document no."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = LoanHeader_ZH."No.";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; EquipmentCode; Code[20])
        {
            Caption = 'Equipment Code';
            TableRelation = Equipment_ZH."Code";

            //validasi jika equipment sedang di maintenance atau blocked
            trigger OnValidate()
            var
                Equipment: Record Equipment_ZH;
                BlockedErr: Label 'Equipment %1 is blocked and cannot be loaned. Select another equipment.';
                MaintenanceErr: Label 'Equipment %1 is under maintenance and cannot be loaned. Select another equipment.';
            begin
                if EquipmentCode = '' then begin
                    Description := '';
                    exit;
                end;

                Equipment.Get(EquipmentCode);
                if Equipment.Blocked then
                    Error(BlockedErr, EquipmentCode);
                if Equipment.Status = Equipment.Status::"Under Maintenance" then
                    Error(MaintenanceErr, EquipmentCode);

                Description := Equipment.Description;
            end;
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(5; "Condition on Loan"; Enum "EquipmentCondition_ZH")
        {
            Caption = 'Condition on Loan';
        }
    }

    keys
    {
        key(PK; "Document no.", "Line No.")
        {
            Clustered = true;
        }
    }

    // Pengamanan agar tidak bisa menambahkan, mengubah, atau menghapus data jika status header bukan open
    trigger OnInsert()
    begin
        CheckHeaderOpen();
    end;

    trigger OnModify()
    begin
        CheckHeaderOpen();
    end;

    trigger OnDelete()
    begin
        CheckHeaderOpen();
    end;

    local procedure CheckHeaderOpen()
    var
        LoanHeader: Record LoanHeader_ZH;
        LockedErr: Label 'Loan %1 is %2 and its lines cannot be changed. Reopen the loan to edit its lines.';
    begin
        LoanHeader.Get("Document no.");
        if LoanHeader.Status <> LoanHeader.Status::Open then
            Error(LockedErr, LoanHeader."No.", LoanHeader.Status);
    end;
}