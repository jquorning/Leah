with LEA_Common.User_options;
with LEA_GWin.Editor;
with LEA_GWin.Messages;
with LEA_GWin.Search_box;
with LEA_Resource_GUI;                  use LEA_Resource_GUI;

with GWindows.Common_Controls;
with GWindows.Drawing;
with GWindows.Image_Lists;
with GWindows.Panels;
with GWindows.Taskbar;                  use GWindows.Taskbar;
with GWindows.Types;
with GWindows.Windows.MDI;
with GWindows.Windows;                  use GWindows.Windows;

with GWin_Util;

with Interfaces.C;

package LEA_GWin.MDI_Main is

  type MDI_Toolbar_Type is
    new GWindows.Common_Controls.Toolbar_Control_Type with null record;

  procedure On_Button_Select (Control : in out MDI_Toolbar_Type;
                              Item    : in     Integer);
  -- Handle click on toolbar

  type IDM_MRU_List is array(LEA_Common.User_options.MRU_List'Range) of Natural;

  type MDI_Main_Type;

  type MDI_Main_Access is access all MDI_Main_Type;

  type LEA_splitter is new GWin_Util.Splitter_with_dashes with record
    MDI_Main: MDI_Main_Access;
  end record;

  overriding procedure On_Bar_Moved (Splitter : in out LEA_splitter);

  type Project_Panel_Type is new GWindows.Panels.Panel_Type with record
    Project_Tree : GWindows.Common_Controls.Tree_View_Control_Type;
    Splitter     : LEA_splitter;
  end record;

  type Message_Panel_Type is new GWindows.Panels.Panel_Type with record
    Message_List : LEA_GWin.Messages.Message_List_Type;
    Splitter     : LEA_splitter;
  end record;

  type MDI_Main_Type is
    new GWindows.Windows.MDI.MDI_Main_Window_Type with
      record
        Project_File_Name      : GString_Unbounded;
        Project_Short_Name     : GString_Unbounded;
        Success_in_enumerated_close: Boolean;
        -- MRU (Most recently used) files names:
        -- Menu ID's stored into a handy array
        IDM_MRU                : IDM_MRU_List;
        Tool_Bar               : MDI_Toolbar_Type;
        Toolbar_Images         : GWindows.Image_Lists.Image_List_Type;
        Folders_Images         : GWindows.Image_Lists.Image_List_Type;
        --
        Project_Panel          : Project_Panel_Type;
        Message_Panel          : Message_Panel_Type;
        --
        Menu                   : Menu_MDI_Main_Type;
        -- record_dimensions      : Boolean:= False; -- in On_Move, On_Size
        User_maximize_restore  : Boolean:= True;
        -- ^ Detect user-triggered max/restore commands
        record_dimensions      : Boolean:= False; -- in On_Move, On_Size
        -- Options of a "model" child window.
        opt                    : LEA_Common.User_options.Option_Pack_Type;
        --
        Task_bar_gadget_ok     : Boolean := False;  --  Coloring of taskbar icon (Windows 7+)
        Task_bar_gadget        : Taskbar_List;
        --
        Search_box             : LEA_GWin.Search_box.LEA_search_box_type;
        --
        is_closing             : Boolean:= False;  --  True only during and after On_Close
        --  Direct input stream from an editor window:
        current_editor_stream  : aliased LEA_GWin.Editor.Editor_Stream_Type;
        build_successful       : Boolean := False;
        close_this_search_box  : Boolean := False;
        pragma Volatile (close_this_search_box);
      end record;

  overriding procedure On_Create (MDI_Main : in out MDI_Main_Type);
  --  Handles setting up icons, menus, etc.

  procedure On_File_New (MDI_Main : in out MDI_Main_Type; extra_first_doc: Boolean);
  --  File|New event

  procedure On_Move (MDI_Main : in out MDI_Main_Type;
                     Left     : in     Integer;
                     Top      : in     Integer);

  overriding procedure On_Size (MDI_Main : in out MDI_Main_Type;
                                Width    : in     Integer;
                                Height   : in     Integer);

  overriding procedure On_File_Drop (MDI_Main   : in out MDI_Main_Type;
                                     File_Names : in     Array_Of_File_Names);

  overriding procedure On_Erase_Background
     (MDI_Main : in out MDI_Main_Type;
      Canvas   : in out GWindows.Drawing.Canvas_Type;
      Area     : in     GWindows.Types.Rectangle_Type) is null;
  overriding procedure On_Paint
     (MDI_Main : in out MDI_Main_Type;
      Canvas   : in out GWindows.Drawing.Canvas_Type;
      Area     : in     GWindows.Types.Rectangle_Type) is null;

  procedure Redraw_all (MDI_Main: in out MDI_Main_Type);

  procedure Open_Child_Window_And_Load (
    MDI_Main     : in out MDI_Main_Type;
    File_Name    :        GWindows.GString_Unbounded;
    Line         :        Integer := -1;
    Col_a, Col_z :        Integer := -1
  );

  overriding procedure On_Menu_Select (
        MDI_Main : in out MDI_Main_Type;
        Item     : in     Integer        );

  overriding
  procedure On_Message (MDI_Main : in out MDI_Main_Type;
                        message      : in     Interfaces.C.unsigned;
                        wParam       : in     GWindows.Types.Wparam;
                        lParam       : in     GWindows.Types.Lparam;
                        Return_Value : in out GWindows.Types.Lresult);

  overriding procedure On_Close (
        MDI_Main  : in out MDI_Main_Type;
        Can_Close :    out Boolean        );

  procedure Update_Common_Menus(
    MDI_Main       : in out MDI_Main_Type;
    top_entry_name : GString := "";
    top_entry_line : Integer := -1    --  When unknown, -1; otherwise: last visited line
  );

  procedure Update_Title (MDI_Main : in out MDI_Main_Type);

  procedure Perform_Search (MDI_Main : MDI_Main_Type; action : LEA_Common.Search_action);

  --  One or more splitter position may have changed, either directly or via a window
  --  resize. Time is to record the proportions.
  procedure Memorize_Splitters (MDI_Main : in out MDI_Main_Type);

end LEA_GWin.MDI_Main;
