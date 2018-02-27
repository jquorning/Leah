with GWindows.Base;
with GWindows.Common_Controls.Ex_List_View;
with GWindows.Drawing_Objects;

package LEA_GWin.Messages is

  --  Information attached to each line in the message box - "dope" or "payload"
  type Dope_information is record
    file   : GString_Unbounded;
    line,
    col    : Natural           := 0;
  end record;

  null_dope : constant Dope_information := (others => <>);

  package LEA_LV_Ex is new GWindows.Common_Controls.Ex_List_View (Dope_information);

  type Message_List_Type is new LEA_LV_Ex.Ex_List_View_Control_Type with record
    mdi_main_parent : GWindows.Base.Pointer_To_Base_Window_Class;
    Font            : GWindows.Drawing_Objects.Font_Type;
  end record;

  overriding procedure On_Click (Control : in out Message_List_Type);
  overriding procedure On_Double_Click (Control : in out Message_List_Type);

  --  Width of broadest message column in pixels.
  --  Ideally a function using something like mdi parent's Client_Area_Width
  large_message_width : constant := 1000;

end LEA_GWin.Messages;