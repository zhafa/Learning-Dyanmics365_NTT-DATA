table 50200 Equipment_ZH
{
    Caption = 'Equipment';
    DataClassification = CustomerContent;
    LookupPageId = "Equipmentlist_ZH";
    DrillDownPageId = "Equipmentlist_ZH";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';

            trigger OnValidate()
            var
                EquipmentSetup: Record "EquipmentSetup_ZH";
                NoSeries: Codeunit "No. Series";
            begin
                if "Code" <> xRec."Code" then begin
                    EquipmentSetup.GetSetup();
                    NoSeries.TestManual(EquipmentSetup."Equipment Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Description; Text[100]) { Caption = 'Description'; }
        field(3; Category; enum "EquipmentCategory_ZH")
        {
            Caption = 'Category';
        }
        field(4; Status; Enum "EquipmentStatus_ZH")
        {
            Caption = 'Status';
            InitValue = Available;
        }
        field(5; Blocked; Boolean) 
        { 
            Caption = 'Blocked'; 
        }
        field(6; "Current Holder"; Code[20])
        {
            Caption = 'Current Holder';
            TableRelation = Employee."No.";
            Editable = false;
        }
          
        field(10; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(PK; "Code") { Clustered = true; }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description, Category, Status) { }
    }

    trigger OnInsert()
    var
        EquipmentSetup: Record "EquipmentSetup_ZH";
        NoSeries: Codeunit "No. Series";
        SetupErr: Label 'Equipment Nos. must be specified in Equipment Setup before new equipment can be created.';
    begin
        if "Code" = '' then begin
            EquipmentSetup.GetSetup();
            if EquipmentSetup."Equipment Nos." = '' then
                Error(SetupErr);
            "No. Series" := EquipmentSetup."Equipment Nos.";
            "Code" := NoSeries.GetNextNo("No. Series", WorkDate());
        end;
    end;
}