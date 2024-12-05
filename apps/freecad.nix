{ pkgs, config, theme, lib, ... }:

let
  colors = import ../colors.nix {
    inherit theme;
    inherit lib;
  };
  qssContent = with config.colorScheme.palette;
    with colors; ''
/*
vi: ft=css

CUSTOMIZATION
============================================================================================================
The colors of the theme have been modified from the original as such:
    BACKGROUND (darker to lighter)
        #${base02}
        #${base02}
        #${base01} = background
        #${base01}
        #${base01}
        #${base01}
        #${base01} = main background color
        #${base00} = secondary
        #${base00}
        #8888ff
        #${base03}*
        #${base03}
        #ff8888
        #888800
        #${base04}
        #${base05}
        #${base0C}

    SELECTION (darker to lighter)
        #${base03}
        #${base04}
        #${focused}
        #${focused} = main selection color
        #00ffff = used to build QSpinBox up and down buttons, it's used as color in the middle
        #${base03}
        #${focused}
        #${base07}


KNOWN BUGS and TO DO
============================================================================================================
See this link to get updated information about the original theme: https://forum.freecadweb.org/viewtopic.php?f=10&t=12417

*/


/*==================================================================================================
Reset elements
==================================================================================================*/
/* Resetting everything helps to unify styles across different operating systems */
* {
    padding: 0px;
    margin: 0px;
    border: 0px;
    border-style: none;
    border-image: none;
    outline: 0;
    color: #${base05}; /* Default color for labels and different text elements that usually use dark colors */
}

/* specific reset for elements inside QToolBar */
QToolBar * {
    margin: 0px;
    padding: 0px;
}


/*==================================================================================================
Main window
==================================================================================================*/
QMainWindow,
QDialog,
QDockWidget,
QToolBar  {
    background-color: #${base01}; /* main background color */
}

QMdiArea {
    background-image: url(qss:images_dark-light/background_freecad_dark.svg);
    background-position: center center;
    background-repeat: no-repeat;
}


/*==================================================================================================
Sub windows
==================================================================================================*/
QMdiSubWindow {
    border:1px solid #${base01};
    margin-top: 30px;
    margin-left: 4px;
    margin-right: 4px;
    margin-bottom:4px;
}


/*==================================================================================================
MENUS
==================================================================================================*/
QMenuBar,
QMenuBar::item {
    color: #${base05};
    background-color: #${base01}; /* main background color */
}

QMenu,
QMenu::item {
    color: #${base05};
    background-color: #${base01};
    text-decoration: none;
}

QMenuBar::item:selected,
QMenuBar::item:pressed,
QMenu::item:selected,
QMenu::item:pressed {
    color: #${base07};
    background-color: #${base04};
}

QMenuBar::item:disabled,
QMenu::item:disabled {
    color: #${base04};
}

QMenu::right-arrow {
    width: 10px;
    height: 10px;
    image:url(qss:images_dark-light/right_arrow_light.svg);
    margin-right: 2px;
}

QMenu::right-arrow:selected {
    image:url(qss:images_dark-light/right_arrow_lighter.svg);
}

QMenu::item {
    padding: 2px 14px 2px 4px; /* make room for icon at left and arrow at right */
    border: 1px solid transparent; /* reserve space for selection border */
}

QMenu::icon {
    margin-left: 1px;
    margin-right: 1px;
}

QMenu::icon:checked { /* appearance of a 'checked' icon */
    background: #${focused};
    border: 2px #${focused};
    position: absolute;
    border-radius: 2px;
}

QMenu::separator {
    height: 1px;
    background-color: rgba(255,255,255,30);
    margin: 6px 4px;
}

QMenu::indicator:non-exclusive {
    width: 10px;
    height: 10px;
    margin-left: 5px;
    margin-right: 2px;
    border: 2px solid #${base03};
    border-radius: 2px;
}

QMenu::indicator:non-exclusive:checked {
    image:url(qss:images_dark-light/checkbox_light.svg);
}

/* Fix for elements inside a drop-down menu */
QMenu QRadioButton,
QMenu QCheckBox,
QMenu QPushButton,
QMenu QToolButton {
    color: #${base0C}; /* same as regular QRadioButton and QCheckBox */
}

QMenu QRadioButton:hover,
QMenu QCheckBox:hover,
QMenu QPushButton:hover,
QMenu QToolButton:hover,
QMenu QPushButton:pressed,
QMenu QToolButton:pressed,
QMenu QPushButton:selected,
QMenu QToolButton:selected {
    color: #${base0C};
    background-color: #${base04}; /* same as QMenu::item:selected and QMenu::item:pressed */
}

QMenu QRadioButton:disabled,
QMenu QCheckBox:disabled {
    color: #${base05};
}

QMenu QRadioButton::indicator:disabled,
QMenu QCheckBox::indicator:disabled {
    color: #${base05};
    background-color: transparent;
    border: 1px solid #${base05};
}


/*==================================================================================================
Tool bar
==================================================================================================*/
QToolBar {
    padding: 2px;
}

QToolBar::handle:top,
QToolBar::handle:bottom,
QToolBar::handle:horizontal {
    background-image: url(qss:images_dark-light/Hmovetoolbar_light.svg);
    width: 10px;
    margin: 4px 2px;
    background-position: top right;
    background-repeat: repeat-y;
}

QToolBar::handle:left,
QToolBar::handle:right,
QToolBar::handle:vertical {
    background-image: url(qss:images_dark-light/Vmovetoolbar_light.svg);
    height: 10px;
    margin: 2px 4px;
    background-position: left bottom;
    background-repeat: repeat-x;
}

QToolBar::separator:top,
QToolBar::separator:bottom,
QToolBar::separator:horizontal {
    width: 1px;
    margin: 6px 4px;
    background-color: rgba(0,0,0,30);
}

QToolBar::separator:left,
QToolBar::separator:right,
QToolBar::separator:vertical {
    height: 1px;
    margin: 4px 6px;
    background-color: rgba(0,0,0,30);
}


/*==================================================================================================
Group box
==================================================================================================*/
QGroupBox {
    color: rgba(255,255,255,120);
    border:1px solid rgba(255,255,255,20); /* lighter than its own border-color */;
    border-radius: 3px;
    margin-top: 10px;
    padding: 6px;
    background-color: rgba(255,255,255,0);
}

QGroupBox:title {
    top: -8px;
    left: 12px;
}

/* NOTE: QGroupBox checkboxes are styles with regular ones so that the all get the same style */
/* QGroupBox::indicator {
    width: 13px;
    height: 13px;
}

QGroupBox::indicator:unchecked {
    image: url(:/images/checkbox_unchecked.png);
} */


/*==================================================================================================
Tooltip
==================================================================================================*/
QToolTip {
    color: #${base07};
    background-color: #${base02};
    /*opacity: 90%; doesn't correctly work */
    padding: 4px;
    border-radius: 3px; /* has no effect */
}


/*==================================================================================================
Dock widget
==================================================================================================*/
QDockWidget {
    color: #8888ff;
    titlebar-close-icon: url(qss:images_dark-light/close_light.svg);
    titlebar-normal-icon: url(qss:images_dark-light/undock_light.svg);
}

QDockWidget::title {
    text-align: center;
    background-color: rgba(0,0,0,40);
    border: 4px solid #${base01}; /* fix to simulate margin between this :title and tabs */ /* same as main background color */
    border-radius: 6px; /* bigger than normal due to previous border fix */
    padding: 4px 0px; /* also needed because of previous border fix */
}

QDockWidget::close-button,
QDockWidget::float-button {
    border: none;
    background: transparent;
    border-radius: 3px;
    subcontrol-origin: padding;
    subcontrol-position: right center;
}

QDockWidget::close-button {
    right: 4px;
}

QDockWidget::float-button {
    right: 22px;
}

QDockWidget::close-button:hover,
QDockWidget::float-button:hover {
    background-color: rgba(0,0,0,60);
}

QDockWidget::close-button:pressed,
QDockWidget::float-button:pressed {
    background-color: rgba(0,0,0,120);
}

/* fix for Python Console (probably there is a smarter way to arrive to it) */
QDockWidget > QFrame {
    background-color: #${base00};
    border: 1px solid #${base01};
}


/*==================================================================================================
Progress bar
==================================================================================================*/
QProgressBar,
QProgressBar:horizontal {
    color: #${base0C};
    background-color: rgba(0,0,0,70);
    text-align: center;
    border: 1px solid rgba(0,0,0,140);
    padding: 1px;
    border-radius: 3px;
}
QProgressBar::chunk,
QProgressBar::chunk:horizontal {
    background-color: qlineargradient(spread:pad, x1:1, y1:0.545, x2:1, y2:0, stop:0 #${focused}, stop:1 #${focused});
    border-radius: 3px;
}


/*==================================================================================================
Scroll
==================================================================================================*/
QAbstractScrollArea {
    border-radius: 2px;
    background-color: transparent;
}

QAbstractScrollArea::corner {
    border: none;
    background-color: transparent;
}

QScrollBar:horizontal {
    background-color: transparent;
    height: 15px;
    margin: 0px;
}

QScrollBar::handle:vertical,
QScrollBar::handle:horizontal {
    background-color: rgba(255,255,255,80);
}

QScrollBar::handle:vertical:hover,
QScrollBar::handle:horizontal:hover {
    background-color: rgba(255,255,255,100);
}

QScrollBar::handle:horizontal {
    min-width: 5px;
    border-radius: 3px;
    margin: 4px 15px;
}

QScrollBar::sub-line:horizontal {
    margin: 1px 3px 0px 3px; /* 1px to correctly fit the 10px width image */
    border-image: url(qss:images_dark-light/left_arrow_light.svg);
    width: 6px;
    height: 10px;
    subcontrol-position: left;
    subcontrol-origin: margin;
}

QScrollBar::add-line:horizontal {
    margin: 1px 3px 0px 3px; /* 1px to correctly fit the 10px width image */
    border-image: url(qss:images_dark-light/right_arrow_light.svg);
    width: 6px;
    height: 10px;
    subcontrol-position: right;
    subcontrol-origin: margin;
}

QScrollBar::sub-line:horizontal:hover,
QScrollBar::sub-line:horizontal:on {
    border-image: url(qss:images_dark-light/left_arrow_lighter.svg);
}

QScrollBar::add-line:horizontal:hover,
QScrollBar::add-line:horizontal:on {
    border-image: url(qss:images_dark-light/right_arrow_lighter.svg);
}

QScrollBar::up-arrow:horizontal,
QScrollBar::down-arrow:horizontal {
    background-color: none;
}

QScrollBar::add-page:horizontal,
QScrollBar::sub-page:horizontal {
    background-color: transparent;
}

QScrollBar:vertical {
    background-color: transparent;
    width: 15px;
    margin: 0px;
}

QScrollBar::handle:vertical {
    min-height: 5px;
    border-radius: 3px;
    margin: 15px 4px;
}

QScrollBar::sub-line:vertical {
    margin: 3px 0px 3px 1px; /* 1px to correctly fit the 10px width image */
    border-image: url(qss:images_dark-light/up_arrow_light.svg);
    height: 6px;
    width: 10px;
    subcontrol-position: top;
    subcontrol-origin: margin;
}

QScrollBar::add-line:vertical {
    margin: 3px 0px 3px 1px; /* 1px to correctly fit the 10px width image */
    border-image: url(qss:images_dark-light/down_arrow_light.svg);
    height: 6px;
    width: 10px;
    subcontrol-position: bottom;
    subcontrol-origin: margin;
}

QScrollBar::sub-line:vertical:hover,
QScrollBar::sub-line:vertical:on {
    border-image: url(qss:images_dark-light/up_arrow_lighter.svg);
}

QScrollBar::add-line:vertical:hover,
QScrollBar::add-line:vertical:on {
    border-image: url(qss:images_dark-light/down_arrow_lighter.svg);
}

QScrollBar::up-arrow:vertical,
QScrollBar::down-arrow:vertical {
    background-color: none;
}

QScrollBar::add-page:vertical,
QScrollBar::sub-page:vertical {
    background-color: transparent;
}


/*==================================================================================================
Tab bar
==================================================================================================*/
QTabWidget::pane {
    background-color: transparent; /* temporal (transparent background) */ /* tab content background color */
    position: absolute;
}

QTabWidget::pane:top {
    top: -1px;
    border-top: 1px solid #${base00};
}

QTabWidget::pane:bottom {
    bottom: -1px;
    border-bottom: 1px solid #${base00};
}

QTabWidget::pane:left {
    right: -1px;
    border-right: 1px solid #${base00};
}

QTabWidget::pane:right {
    left: -1px;
    border-left: 1px solid #${base00};
}

QTabWidget::tab-bar:top,
QTabWidget::tab-bar:bottom {
    left: 10px;
}

QTabWidget::tab-bar:left,
QTabWidget::tab-bar:right {
    top: 10px;
}

QTabBar {
    qproperty-drawBase: 0; /* important */
    background-color: transparent;
}

/* Workaround for QTabBars created from docked QDockWidgets which don't draw the border if not set and reset as follows: */
QTabBar {
    border-top: 1px solid #${base00};  /* set color for all QTabBars */
}
QDockWidget QTabBar {
    border-color: transparent; /* set color for all QTabBars but ones created from QDockWidget */
}
QDialog QTabBar {
    border-color: transparent; /* set color for QTabBars inside Preferences dialog */
}
/* end fix */

QTabBar::tab {
    background-color: transparent;
    border: 1px solid transparent;
    padding: 3px;
}

QTabBar::tab:top,
QTabBar::tab:bottom {
    border-top-width: 4px; /* same as selected tab colored border in order to center close-button */
    border-bottom-width: 4px; /* same as selected tab colored border in order to center close-button */
    min-width: 11ex;
    margin-left: 2px;
    margin-right: 2px;
}

QTabBar::tab:left,
QTabBar::tab:right {
    border-left-width: 4px; /* same as selected tab colored border in order to center close-button */
    border-right-width: 4px; /* same as selected tab colored border in order to center close-button */
    min-height: 14ex;
    margin-top: 2px;
    margin-bottom: 2px;
}

QTabBar::tab:selected {
    color: #${base05};
    background-color: #${base01}; /* same as tab content background color */
    border-color: #${base00};
}

QTabBar::tab:top:selected {
    border-top: 4px solid qlineargradient(spread:pad, x1:0, y1:0, x2:0, y2:1, stop:0 #${focused}, stop:1 #${focused}); /* selection color */
    border-bottom-color: #${base01}; /* same as tab content background color */
}

QTabBar::tab:bottom:selected {
    border-bottom: 4px solid qlineargradient(spread:pad, x1:0, y1:0, x2:0, y2:1, stop:0 #${focused}, stop:1 #${focused}); /* selection color */
    border-top-color: #${base01}; /* same as tab content background color */
}

QTabBar::tab:right:selected {
    border-left: 4px solid qlineargradient(spread:pad, x1:0, y1:0, x2:1, y2:0, stop:0 #${focused}, stop:1 #${focused}); /* selection color */
    border-right-color: #${base01}; /* same as tab content background color */
}

QTabBar::tab:left:selected {
    border-right: 4px solid qlineargradient(spread:pad, x1:0, y1:0, x2:1, y2:0, stop:0 #${focused}, stop:1 #${focused}); /* selection color */
    border-left-color: #${base01}; /* same as tab content background color */
}

QTabBar::tab:!selected {
    color: rgba(255,255,255,120);
}

QTabBar::tab:!selected:hover {
    color: rgba(255,255,255,180);
    background-color: rgba(255,255,255,20);
}

QTabBar::tab:first:selected {
    margin-left: 0; /* the first selected tab has nothing to overlap with on the left */
}

QTabBar::tab:last:selected {
    margin-right: 0; /* the last selected tab has nothing to overlap with on the right */
}

QTabBar::tab:only-one {
    margin: 0; /* if there is only one tab, we don't want overlapping margins */
}

/* hack to access Preference TabBar background */
QDialog#Gui__Dialog__DlgPreferences > QFrame QFrame {
    background-color: transparent; /* main background color (in Windows is #${base01}) */
}

/* fix for previous hack that broke QTabWidget background on Windows */
QDialog#Gui__Dialog__DlgPreferences QTabWidget::pane {
    background-color: transparent; /* temporal (transparent background) */
}

/* hack to correctly align Preferences icon list on OSX */
QDialog#Gui__Dialog__DlgPreferences > QListView {
    min-width: 130px;
}

/* unique styles for sections inside Preferences */
QDialog#Gui__Dialog__DlgPreferences > QListView::item {
    border-radius: 4px;
}

QDialog#Gui__Dialog__DlgPreferences > QListView::item:hover {
    background-color: #${base00};
}

QDialog#Gui__Dialog__DlgPreferences > QListView::item:selected {
    color: #${base0C};
    background-color: #${base04};
}


/*==================================================================================================
Tab bar buttons
==================================================================================================*/
/* Close button */
QTabBar::close-button {
    subcontrol-origin: margin;
    subcontrol-position: center right; /* only works for Qt 4.6 and newer */;
    border-radius: 2px;
    background-image: url(qss:images_dark-light/close_light.svg);
    background-position: center center;
    background-repeat: none;
}

QTabBar::close-button:hover {
    background-color: rgba(255,255,255,20);
}

QTabBar::close-button:pressed {
    background-color: rgba(255,255,255,30);
}

/* Fix for lists inside Model tab */
QDockWidget QTreeView,
QDockWidget QListView,
QDockWidget QTableView {
    margin: 6px;
    border: 1px solid #${base01}; /* same as regular QTreeView, QListView and QTableView */
    min-height: 40px; /* necessary in some areas of FreeCAD */
}

/*=================================================================================================
Tab bar scroll buttons
=================================================================================================*/

QTabBar::scroller { /* only accepts width property */
    width: 80px; /* the width of the scroll buttons */
}

QTabBar QToolButton { /* same properties as QDialog QToolButton */
    color: #${base04};
    text-align: center;
    background-color: #44475a;
    border: 1px solid #${base02};
    border-bottom-color: #${base02}; /* simulates shadow under the button */
    padding: 0px; /* different than regular QPushButton */
    margin: 2px; /* different than regular QPushButton */
    min-height: 16px; /* same as QTabBar QPushButton min-width */
    border-radius: 4px;
}

QTabBar QToolButton:hover,
QTabBar QToolButton:focus {
    color: #${base07};
    border-color: #${base03};
    background-color: qlineargradient(spread:pad, x1:0, y1:0, x2:0, y2:1, stop:0 #${base03}, stop:1 #${base03});
}

QTabBar QToolButton:disabled,
QQTabBar QToolButton:disabled:checked {
    color: #${base01};
    border-color: #${base01};
    background-color: #${base01};
}

QTabBar QToolButton:pressed {
    background-color: qlineargradient(spread:pad, x1:0, y1:0, x2:0, y2:1, stop:0 #${base03}, stop:1 #${base03});
}

QTabBar QToolButton::right-arrow { /* the arrow mark in the tool buttons */
    image:url(qss:images_dark-light/right_arrow_light.svg);
    padding-left:10px;
    padding-right:5px;
    padding-top:5px;
    padding-bottom:3px;
}

QTabBar QToolButton::right-arrow:disabled,
QTabBar QToolButton::right-arrow:off {
    image: url(qss:images_dark-light/right_arrow_disabled_light.svg);
    /* todo */
}

QTabBar QToolButton::right-arrow:hover {
    image:url(qss:images_dark-light/right_arrow_lighter.svg);
}

QTabBar QToolButton::left-arrow { /* the arrow mark in the tool buttons */
    image:url(qss:images_dark-light/left_arrow_light.svg);
    padding-left:5px;
    padding-right:10px;
    padding-top:5px;
    padding-bottom:3px;
}

 QTabBar QToolButton::left-arrow:disabled,
 QTabBar QToolButton::left-arrow:off {
     image: url(qss:images_dark-light/left_arrow_disabled_light.svg);
    /* todo */
}

 QTabBar QToolButton::left-arrow:hover {
    image:url(qss:images_dark-light/left_arrow_lighter.svg);
}

 QTabBar QToolButton::up-arrow:enabled {
     image: url(qss:images_dark-light/up_arrow_light.svg);
}

 QTabBar QToolButton::up-arrow:disabled,
 QTabBar QToolButton::up-arrow:off {
     image: url(qss:images_dark-light/up_arrow_disabled_light.svg);
}

 QTabBar QToolButton::up-arrow:hover {
     image: url(qss:images_dark-light/up_arrow_lighter.svg);
}

 QTabBar QToolButton::down-arrow:enabled {
     image: url(qss:images_dark-light/down_arrow_light.svg);
}

 QTabBar QToolButton::down-arrow:disabled,
 QTabBar QToolButton::down-arrow:off {
     image: url(qss:images_dark-light/down_arrow_disabled_light.svg);
}

 QTabBar QToolButton::down-arrow:hover {
     image: url(qss:images_dark-light/down_arrow_lighter.svg);
}

QTabBar::tear {
    /* default OS tear better */
}


/*==================================================================================================
Tree and list views
==================================================================================================*/
QTreeView,
QListView,
QTableView {
    color: #${base07};
    background-color: #${base00};
    alternate-background-color: #${base01}; /* related with QListView background  */
    border: 1px solid #${base01};
    selection-color: #${base07};
    selection-background-color: #${base04}; /* should be similar to QListView::item selected background-color */
    border-radius: 3px;
}

QListView::item:selected,
QTreeView::item:selected  {
    color: #${base07}; /* should be similar to QListView selection-color */
    background-color: #${base04}; /* should be similar to QListView selection-background-color */
}

QTreeView {
    show-decoration-selected: 0;
}

QListView,
QTableView {
    show-decoration-selected: 1;
}

/* Property Editor QTreeView (FreeCAD custom widget) */
Gui--PropertyEditor--PropertyEditor {
    gridline-color: #${base01}; /* same as Group header background */
}

/* Cells with values that can only be changed with "..." button (Attachment)
/* These seem to draw on top of the underlying label, so must be completely hidden or have an opaque background */
Gui--PropertyEditor--PropertyEditor > QWidget > QWidget > QLabel {
	color: #${base03};
	background-color: #${base04};
	margin-left:1px;
}

/* Cells with values that can only be changed with "..." button, but are disabled (Placement) */
/* These seem to draw on top of the underlying label, so must be completely hidden or have an opaque background */
Gui--PropertyEditor--PropertyEditor > QWidget > QWidget > QLabel:disabled {
	color: transparent;
	background-color: transparent;
}

QLabel[haslink="true"] { /* applies to all links (See Help->About), but most importantly in PropertyEditor. Trying to specify PropertyEditor fails.*/
    color: #${focused};
}

/* hack to disable margin inside Property values to following elements */
Gui--PropertyEditor--PropertyEditor QSpinBox,
Gui--PropertyEditor--PropertyEditor QDoubleSpinBox,
Gui--PropertyEditor--PropertyEditor QAbstractSpinBox,
Gui--PropertyEditor--PropertyEditor QLineEdit,
Gui--PropertyEditor--PropertyEditor QComboBox {
    margin-left: 0px;
    margin-right: 0px;
    padding-top: 0px;
    padding-bottom: 0px;
}

Gui--PropertyEditor--PropertyEditor QSpinBox:disabled,
Gui--PropertyEditor--PropertyEditor QDoubleSpinBox:disabled,
Gui--PropertyEditor--PropertyEditor QAbstractSpinBox:disabled,
Gui--PropertyEditor--PropertyEditor QLineEdit:disabled,
Gui--PropertyEditor--PropertyEditor QComboBox:disabled {
    selection-background-color:transparent;
}

/* reset min-height to 0px inside list views */
QTreeView > QWidget > QComboBox,
QTreeView > QWidget > QAbstractSpinBox,
QTreeView > QWidget > QSpinBox,
QTreeView > QWidget > QDoubleSpinBox,
QTreeView > QWidget > QLineEdit,
QTreeView > QWidget > QTextEdit,
QTreeView > QWidget > QTimeEdit,
QTreeView > QWidget > QDateEdit,
QTreeView > QWidget > QDateTimeEdit,
QTreeView > QWidget > Gui--ColorButton {
    min-height: 0px;
}

/* set border-radius to 0px inside list views */
QTreeView > QWidget > QComboBox,
QTreeView > QWidget > QAbstractSpinBox,
QTreeView > QWidget > QSpinBox,
QTreeView > QWidget > QDoubleSpinBox,
QTreeView > QWidget > QLineEdit,
QTreeView > QWidget > QTextEdit,
QTreeView > QWidget > QTimeEdit,
QTreeView > QWidget > QDateEdit,
QTreeView > QWidget > QDateTimeEdit,
QTreeView > QWidget > QComboBox:drop-down,
QTreeView > QWidget > QAbstractSpinBox:up-button,
QTreeView > QWidget > QSpinBox:up-button,
QTreeView > QWidget > QDoubleSpinBox:up-button,
QTreeView > QWidget > QTimeEdit:up-button,
QTreeView > QWidget > QDateEdit:up-button,
QTreeView > QWidget > QDateTimeEdit:up-button,
QTreeView > QWidget > QAbstractSpinBox:down-button,
QTreeView > QWidget > QSpinBox:down-button,
QTreeView > QWidget > QDoubleSpinBox:down-button,
QTreeView > QWidget > QTimeEdit:down-button,
QTreeView > QWidget > QDateEdit:down-button,
QTreeView > QWidget > QDateTimeEdit:down-button,
QTreeView > QWidget > Gui--ColorButton {
    border-radius: 0px;
}

/* set focus colors to best viewing the editable fields */
QTreeView > QWidget > QComboBox:focus,
QTreeView > QWidget > QAbstractSpinBox:focus,
QTreeView > QWidget > QSpinBox:focus,
QTreeView > QWidget > QDoubleSpinBox:focus,
QTreeView > QWidget > QLineEdit:focus,
QTreeView > QWidget > QTextEdit:focus,
QTreeView > QWidget > QTimeEdit:focus,
QTreeView > QWidget > QDateEdit:focus,
QTreeView > QWidget > QDateTimeEdit:focus {
    border-color: transparent; /* same as focused background color */
    border-bottom-color: #${base02}; /* same as focused border color */
}

/* Fix to correctly (not totally) draw QTextEdit on OSX at Page properties: "Page result", "Template" and "Editable Texts" */
Gui--PropertyEditor--PropertyEditor > QWidget > QWidget > QWidget {
    min-height: 14px;
    border-radius: 0px; /* reset */
}


/*==================================================================================================
Header of tree and list views
==================================================================================================*/
QHeaderView {
    color: #888800;
    background-color: #${base01};
    border-top-left-radius: 2px; /* 1px less than its container */
    border-top-right-radius: 2px; /* 1px less than its container */
    border-bottom-left-radius: 0px;
    border-bottom-right-radius: 0px;
}

QHeaderView::section {
    border:none;
    padding: 4px 6px;
    background-color: #${base01};
}

QHeaderView::section:hover {
    background-color: #${base00};
}

QHeaderView::section:horizontal {
    padding: 4px 6px; /* left and right value similar to QHeaderView::section */
    border-right: 1px solid rgba(255,255,255,30);
}

QHeaderView::section:vertical {
    border-bottom: 1px solid rgba(255,255,255,30);
}

QTableCornerButton::section {
    background-color: #${base01};
    border-top: none;
    border-left: none;
    border-right: 1px solid rgba(255,255,255,30);
    border-bottom: 1px solid rgba(255,255,255,30);
}

QHeaderView::section:last {
    border-right: none;
}

QHeaderView::up-arrow {
    image: url(qss:images_dark-light/up_arrow_light.svg);
}

QHeaderView::up-arrow:hover {
    image: url(qss:images_dark-light/up_arrow_lighter.svg);
}

QHeaderView::down-arrow {
    image: url(qss:images_dark-light/down_arrow_light.svg);
}

QHeaderView::down-arrow:hover {
    image: url(qss:images_dark-light/down_arrow_lighter.svg);
}

/* Group header inside Property Editor (FreeCAD custom widget) */
Gui--PropertyEditor--PropertyEditor {
    qproperty-groupTextColor: #${base03};
    qproperty-groupBackground: #${base01};
}


/*==================================================================================================
Branch system for QTreeViews
==================================================================================================*/
QTreeView::branch  {
    background: transparent;
}

QTreeView::branch:has-siblings:!adjoins-item  {
    border-image: url(qss:images_dark-light/branch_vline_light.svg) 0;
}

QTreeView::branch:has-siblings:adjoins-item  {
    border-image: url(qss:images_dark-light/branch_more_light.svg) 0;
}

QTreeView::branch:!has-children:!has-siblings:adjoins-item  {
    border-image: url(qss:images_dark-light/branch_end_light.svg) 0;
}

QTreeView::branch:closed:has-children:has-siblings  {
    border-image: url(qss:images_dark-light/branch_more_closed_light.svg) 0;
}

QTreeView::branch:has-children:!has-siblings:closed  {
    border-image: url(qss:images_dark-light/branch_end_closed_light.svg) 0;
}

QTreeView::branch:open:has-children:has-siblings  {
    border-image: url(qss:images_dark-light/branch_more_open_light.svg) 0;
}

QTreeView::branch:open:has-children:!has-siblings  {
    border-image: url(qss:images_dark-light/branch_end_open_light.svg) 0;
}


/*==================================================================================================
Splitter and windows separator
==================================================================================================*/
QSplitter::handle {
    margin: 0px 11px;
    padding: 0px;
}

QSplitter::handle:horizontal {
    background-image: url(qss:images_dark-light/splitter_vertical_light.svg);
    background-position: center center;
    background-repeat: none;
    margin: 4px 2px 4px 2px;
    width: 2px;
}

QSplitter::handle:vertical {
    background-image: url(qss:images_dark-light/splitter_horizontal_light.svg);
    background-position: center center;
    background-repeat: none;
    margin: 2px 4px 2px 4px;
    height: 2px;
}

/* Similar to the splitter is the following window separator (but horizontal/vertical is on the opposite way) */
QMainWindow::separator {
    background-position: center center;
    background-repeat: none;
}

QMainWindow::separator:horizontal {
    height: 2px;
    background-image: url(qss:images_dark-light/splitter_horizontal_light.svg);
    margin: 4px 2px 4px 2px;
}

QMainWindow::separator:vertical {
    width: 2px;
    background-image: url(qss:images_dark-light/splitter_vertical_light.svg);
    margin: 2px 4px 2px 4px;
}


/*==================================================================================================
Text/Python editor (macros, etc...)
==================================================================================================*/
QPlainTextEdit,
QPlainTextEdit:focus {
    background-color: #${base00};
    selection-color: #${base07};
    selection-background-color: #${base04};
    border: 1px solid #${base01};
    border-radius: 3px;
    margin: 4px;
}


/*==================================================================================================
Tasks panel (custom FreeCAD class)
==================================================================================================*/
/* Action group */
QFrame[class="panel"] {
    background-color: transparent; /* temporal (transparent background) */
}

QSint--ActionGroup {
    padding: 0px; /* if not reset, it might create problems with QPushButtons and other elements */
    margin: 0px; /* if not reset, it might create problems with QPushButtons and other elements */
}

/* Separator line */
QSint--ActionGroup QFrame[height="1"],
QSint--ActionGroup QFrame[height="2"],
QSint--ActionGroup QFrame[height="3"],
QSint--ActionGroup QFrame[width="1"],
QSint--ActionGroup QFrame[width="2"],
QSint--ActionGroup QFrame[width="3"] {
    border-color: rgba(0,0,0,60);
}

/* Panel header */
QSint--ActionGroup QFrame[class="header"] {
    border: none;
    background-color: #${base01}; /* Task Panel Header background color */
    border-top-left-radius: 3px;
    border-top-right-radius: 3px;
    border-bottom-left-radius: 0px;
    border-bottom-right-radius: 0px;
    margin: 0px;
    padding: 0px;
}

QSint--ActionGroup QFrame[class="header"]:hover {
    background-color: qlineargradient(spread:pad, x1:0, y1:0, x2:0, y2:1, stop:0 #${base03}, stop:1 #${base03});
}

QSint--ActionGroup QToolButton[class="header"] {
    color: #${base05}; /* Task Panel Header text color */
    text-align: left;
    font-weight: bold;
    border: none;
    margin: 0px;
    padding: 0px;
}

QSint--ActionGroup QFrame[class="header"] QLabel {
    background-color: transparent;
    background-image: url(qss:images_dark-light/down_arrow_light.svg);
    background-repeat: none;
    background-position: center center;
    padding: 0px;
    margin: 0px;
}

QSint--ActionGroup QFrame[class="header"] QLabel:hover {
    background-color: transparent;
    background-image: url(qss:images_dark-light/down_arrow_lighter.svg);
}

QSint--ActionGroup QFrame[class="header"] QLabel[fold="true"] {
    background-color: transparent;
    background-image: url(qss:images_dark-light/up_arrow_light.svg);
    background-repeat: none;
    background-position: center center;
    padding: 0px;
    margin: 0px;
}

QSint--ActionGroup QFrame[class="header"] QLabel[fold="true"]:hover {
    background-color: transparent;
    background-image: url(qss:images_dark-light/up_arrow_lighter.svg);
}

QSint--ActionGroup QFrame[class="content"] {
    background-color: #${base00}; /* Task Panel background color */
    margin: 0px;
    padding: 0px;
    border: none;
    border-top-left-radius: 0px;
    border-top-right-radius: 0px;
    border-bottom-left-radius: 3px;
    border-bottom-right-radius: 3px;
}

QSint--ActionGroup QFrame[class="content"] > QWidget {
    background-color: #${base00}; /* Task Panel background color */
}

/* Fixs for tabs inside Task Panel */
QSint--ActionGroup QFrame[class="content"] QTabBar::tab:top:selected {
    border-bottom-color: #${base00}; /* same as Task Panel background color */
}

QSint--ActionGroup QFrame[class="content"] QTabBar::tab:bottom:selected {
    border-top-color: #${base00}; /* same as Task Panel background color */
}

QSint--ActionGroup QFrame[class="content"] QTabBar::tab:right:selected {
    border-right-color: #${base00}; /* same as Task Panel background color */
}

QSint--ActionGroup QFrame[class="content"] QTabBar::tab:left:selected {
    border-left-color: #${base00}; /* same as Task Panel background color */
}

/* Fix for buttons with icons that showed cropped (still not happy with result) */
QSint--ActionGroup QFrame[class="content"] > QWidget > QPushButton {
    padding: 2px; /* bigger padding crops text and icons... */
    margin: 0px;
}

/* Fix for lists inside task panels */
QSint--ActionGroup QFrame[class="content"] QTreeView,
QSint--ActionGroup QFrame[class="content"] QListView,
QSint--ActionGroup QFrame[class="content"] QTableView {
    color: #${base05};
    background-color: #${base00};
}


/*==================================================================================================
Buttons
==================================================================================================*/
/* Common */
QComboBox,
QAbstractSpinBox,
QSpinBox,
QDoubleSpinBox,
QLineEdit,
QTextEdit,
QTimeEdit,
QDateEdit,
QDateTimeEdit {
    color: #${base05};
    background-color: #${base00};
    selection-color: #${base0C};
    selection-background-color: #${base03} ;
    border: 1px solid #${base01};
    border-radius: 3px;
    min-width: 50px; /* it ensures the default value is correctly displayed */
    min-height: 20px; /* important to be a pair number in order to up/down buttons to be divisible by two (if not set could create a blank line in Ubuntu. Its downside is that it's needed to reset it (min-width: 0px) on following elements that can't have it such as fields inside QToolBar and inside QTreeView (Property editor) */
    padding: 1px 2px; /* temporal: could don't be compatible with elements inside Tree/List view */
}

/* more contrast for QTextEdits */
QTextEdit {
    color: #${base02};
}

/* shifts text/number editable field to the left to make space for the up/down or drop-down buttons */
QComboBox,
QAbstractSpinBox,
QSpinBox,
QDoubleSpinBox,
QTimeEdit,
QDateEdit,
QDateTimeEdit {
    padding-right: 20px;
}

/* when QTextEdit are no editable (like Report view)*/
QTextEdit:!editable,
QTextEdit:!editable:focus {
    background-color: #${base00};
    border: 1px solid #${base01};
}

QComboBox:focus,
QAbstractSpinBox:focus,
QSpinBox:focus,
QDoubleSpinBox:focus,
QLineEdit:focus,
QTextEdit:focus,
QTimeEdit:focus,
QDateEdit:focus,
QDateTimeEdit:focus {
    color: #${base05};
    border-color: #${base03};
    border-right-color: qlineargradient(spread:pad, x1:1, y1:0.8, x2:1, y2:0, stop:0 #${base03}, stop:1 #${base03}); /* same as up/down or drop-down button color */
    background-color: #${base04};
}

QComboBox:disabled,
QAbstractSpinBox:disabled,
QSpinBox:disabled,
QDoubleSpinBox:disabled,
QLineEdit:disabled,
QTextEdit:disabled,
QTimeEdit:disabled,
QDateEdit:disabled,
QDateTimeEdit:disabled {
    color: #${base04};
    background-color: #${base01}; /* same as enabled color */
    border-color: #${base01}; /* same as enabled color */
}

QAbstractSpinBox:up-button,
QSpinBox:up-button,
QDoubleSpinBox:up-button,
QTimeEdit:up-button,
QDateEdit:up-button,
QDateTimeEdit:up-button,
QAbstractSpinBox:down-button,
QSpinBox:down-button,
QDoubleSpinBox:down-button,
QTimeEdit:down-button,
QDateEdit:down-button,
QDateTimeEdit:down-button {
    background-color: #${base01}; /* same color for QComboBox background-color */
    subcontrol-origin: border; /* important */
    width: 20px; /* same as QComboBox ... QDateTimeEdit padding-right */
}

QAbstractSpinBox:up-button,
QSpinBox:up-button,
QDoubleSpinBox:up-button,
QTimeEdit:up-button,
QDateEdit:up-button,
QDateTimeEdit:up-button {
    subcontrol-position: top right;
    border-top-right-radius: 3px;
}

QAbstractSpinBox:down-button,
QSpinBox:down-button,
QDoubleSpinBox:down-button,
QTimeEdit:down-button,
QDateEdit:down-button,
QDateTimeEdit:down-button {
    subcontrol-position: bottom right;
    border-bottom-right-radius: 3px;
}

QAbstractSpinBox:up-button:focus,
QSpinBox:up-button:focus,
QDoubleSpinBox:up-button:focus,
QTimeEdit:up-button:focus,
QDateEdit:up-button:focus,
QDateTimeEdit:up-button:focus {
    background-color: qlineargradient(spread:pad, x1:1, y1:0.8, x2:1, y2:0, stop:0 #${base03}, stop:1 #${base03});
}

QAbstractSpinBox:down-button:focus,
QSpinBox:down-button:focus,
QDoubleSpinBox:down-button:focus,
QTimeEdit:down-button:focus,
QDateEdit:down-button:focus,
QDateTimeEdit:down-button:focus {
    background-color: qlineargradient(spread:pad, x1:1, y1:0.8, x2:1, y2:0, stop:0 #${base03}, stop:1 #${base03});
}

QAbstractSpinBox:up-button:disabled,
QSpinBox:up-button:disabled,
QDoubleSpinBox:up-button:disabled,
QTimeEdit:up-button:disabled,
QDateEdit:up-button:disabled,
QDateTimeEdit:up-button:disabled,
QAbstractSpinBox:down-button:disabled,
QSpinBox:down-button:disabled,
QDoubleSpinBox:down-button:disabled,
QTimeEdit:down-button:disabled,
QDateEdit:down-button:disabled,
QDateTimeEdit:down-button:disabled {
    background-color: transparent;
}

QAbstractSpinBox::up-arrow,
QSpinBox::up-arrow,
QDoubleSpinBox::up-arrow,
QTimeEdit::up-arrow,
QDateEdit::up-arrow,
QDateTimeEdit::up-arrow {
    image: url(qss:images_dark-light/up_arrow_light.svg);
    top: 2px; /* fix symmetry between up and down images */
}

QAbstractSpinBox::up-arrow:focus,
QSpinBox::up-arrow:focus,
QDoubleSpinBox::up-arrow:focus,
QTimeEdit::up-arrow:focus,
QDateEdit::up-arrow:focus,
QDateTimeEdit::up-arrow:focus {
    image: url(qss:images_dark-light/up_arrow_lighter.svg);
}

QAbstractSpinBox::up-arrow:off,
QSpinBox::up-arrow:off,
QDoubleSpinBox::up-arrow:off,
QTimeEdit::up-arrow:off,
QDateEdit::up-arrow:off,
QDateTimeEdit::up-arrow:off {
    image: url(qss:images_dark-light/up_arrow_disabled_light.svg);
}

QAbstractSpinBox::up-arrow:disabled,
QSpinBox::up-arrow:disabled,
QDoubleSpinBox::up-arrow:disabled,
QTimeEdit::up-arrow:disabled,
QDateEdit::up-arrow:disabled,
QDateTimeEdit::up-arrow:disabled {
    image: url(qss:images_dark-light/up_arrow_disabled_light.svg);
}

QAbstractSpinBox::down-arrow,
QSpinBox::down-arrow,
QDoubleSpinBox::down-arrow,
QTimeEdit::down-arrow,
QDateEdit::down-arrow,
QDateTimeEdit::down-arrow {
    image: url(qss:images_dark-light/down_arrow_light.svg);
    bottom: 0px; /* fix simetry between up and down images */
}

QAbstractSpinBox::down-arrow:focus,
QSpinBox::down-arrow:focus,
QDoubleSpinBox::down-arrow:focus,
QTimeEdit::down-arrow:focus,
QDateEdit::down-arrow:focus,
QDateTimeEdit::down-arrow:focus {
    image: url(qss:images_dark-light/down_arrow_lighter.svg);
}

QAbstractSpinBox::down-arrow:off,
QSpinBox::down-arrow:off,
QDoubleSpinBox::down-arrow:off,
QTimeEdit::down-arrow:off,
QDateEdit::down-arrow:off,
QDateTimeEdit::down-arrow:off {
    image: url(qss:images_dark-light/down_arrow_disabled_light.svg);
}

QAbstractSpinBox::down-arrow:disabled,
QSpinBox::down-arrow:disabled,
QDoubleSpinBox::down-arrow:disabled,
QTimeEdit::down-arrow:disabled,
QDateEdit::down-arrow:disabled,
QDateTimeEdit::down-arrow:disabled {
    image: url(qss:images_dark-light/down_arrow_disabled_light.svg);
}

/* ComboBox */

QComboBox::drop-down {
    background-color: #${base01}; /* same color as up/down QSpinBox ... QDateTimeView background-color */
    subcontrol-origin: border; /* important */
    subcontrol-position: top right;
    width: 20px;
    border-top-right-radius: 3px;
    border-bottom-right-radius: 3px;
}

QComboBox::drop-down:on,
QComboBox::drop-down:focus {
    background-color: qlineargradient(spread:pad, x1:1, y1:0.8, x2:1, y2:0, stop:0 #${base03}, stop:1 #${base03});
}

QComboBox::down-arrow {
    image: url(qss:images_dark-light/down_arrow_light.svg);
}

QComboBox::down-arrow:on,
QComboBox::down-arrow:focus {
    image: url(qss:images_dark-light/down_arrow_lighter.svg);
}

QComboBox::down-arrow:off,
QComboBox::down-arrow:disabled {
    image: url(qss:images_dark-light/down_arrow_disabled_light.svg);
}

/* ComboBox menu */
QComboBox {
    selection-color: #${base05};
    selection-background-color: #${base04};
}

QComboBox QAbstractItemView {
    color: #${base03}; /* same as regular QComboBox color */
    background-color: transparent;
    selection-color: #${base05};
    selection-background-color: #${base04};
    border-width: 5px 0px 5px 0px;
    border-style: solid;
    border-color: transparent;
    margin: 0px -1px 0px 0px; /* hack for Mac... try it on Windows and Linux */
}


/*==================================================================================================
Push button
==================================================================================================*/
QPushButton {
    color: #${base04};
    text-align: center;
    background-color: qlineargradient(spread:pad, x1:0, y1:0.3, x2:0, y2:1, stop:0 #${base02}, stop:1 #${base02});
    border: 1px solid #${base01};
    border-bottom-color: #${base02}; /* simulates shadow under the button */
    padding: 4px 22px;
    margin: 4px 4px;
    min-height: 16px; /* same as QTabBar QPushButton min-width */
    border-radius: 4px;
}

QPushButton:hover,
QPushButton:focus {
    color: #${base07};
    border-color: #${base03};
    background-color: qlineargradient(spread:pad, x1:0, y1:0, x2:0, y2:1, stop:0 #${base03}, stop:1 #${base03});
}

QPushButton:disabled,
QPushButton:disabled:checked {
    color: #${base01};
    background-color: #${base01}; /* same as enabled color */
    border-color: #${base01}; /* same as enabled color */
}

QPushButton:pressed {
    background-color: qlineargradient(spread:pad, x1:0, y1:0, x2:0, y2:1, stop:0 #${base03}, stop:1 #${base03});
}

QPushButton:checked {
    background-color: #${base04};
    border-color: #${base03};
}

/* Color Buttons */
Gui--ColorButton,
Gui--ColorButton:disabled {
    padding: 0px; /* reset */
    margin: 0px; /* reset */
}

Gui--ColorButton {
    background-color: qlineargradient(spread:pad, x1:0, y1:0.3, x2:0, y2:1, stop:0 #${base02}, stop:1 #${base02});
    border: 1px solid #${base02};
    border-bottom-color: #${base02}; /* simulates shadow under the button */
}

Gui--ColorButton:disabled {
    border-color: transparent;
    background-color: rgba(0,0,0,10);
}

Gui--ColorButton:hover,
Gui--ColorButton:focus {
    border-color: #${base03};
    background-color: qlineargradient(spread:pad, x1:0, y1:0, x2:0, y2:1, stop:0 #${base03}, stop:1 #${base03});
}

Gui--ColorButton:pressed {
    background-color: qlineargradient(spread:pad, x1:0, y1:0, x2:0, y2:1, stop:0 #${base03}, stop:1 #${base03});
}

/* Pushbutton style for "..." inside Placement cell which launches Placement tool */
Gui--PropertyEditor--PropertyEditor > QWidget > QWidget > QPushButton {
    background-color: #${base01};
    border: 1px solid #${base02};
    min-width: 16px; /* reset it due to larger value on regular QPushButton, same or bigger value as regular QPushButton min-height */
    border-radius: 0px;
    margin: 0px; /* reset */
    padding: 0px; /* reset */
}

/* Fix for Expressions description QFrame that is "broken" with initial reset */
Gui--PropertyEditor--PropertyEditor > QWidget > QWidget > QWidget > QWidget > QFrame {
    background-color: #${base01}; /* main background color */
    border: 1px solid #${base01};
    border-radius: 2px;
    padding: 2px 6px;
}

QPushButton:checked {
    background-color: #${base04};
    border-color: #${base04};
}

/* For styling Buttons inside tables, found in Preferences > Preference Packs */
/* Padding & margins specifically for these buttons prevents overlap of buttons between table rows */
QTableWidget QPushButton {
    padding-top:1px;
    padding-bottom:1px;
    padding-left:6px;
    padding-right:6px;
    margin-top:1.5px;
    margin-bottom:1.5px;
    margin-left:2px;
    margin-right:2px;
}


/*==================================================================================================
Tool button inside QDialogs that works as QPushButtons
==================================================================================================*/
/* found under Tools -> Customize -> Macros -> Pixmap "..." button */
/* properties match QToolBar > QToolButton */
QDialog QToolButton {
    color: #${base04};
    text-align: center;
    background-color: #44475a;
    border: 1px solid #${base02};
    border-bottom-color: #${base02}; /* simulates shadow under the button */
    padding: 0px; /* different than regular QPushButton */
    margin: 2px; /* different than regular QPushButton */
    min-height: 16px; /* same as QTabBar QPushButton min-width */
    border-radius: 4px;
}

QDialog QToolButton:hover,
QDialog QToolButton:focus {
    color: #${base07};
    border-color: #${base03};
    background-color: qlineargradient(spread:pad, x1:0, y1:0, x2:0, y2:1, stop:0 #${base03}, stop:1 #${base03});
}

QDialog QToolButton:disabled,
QDialog QToolButton:disabled:checked {
    color: #${base01};
    border-color: #${base01};
    background-color: #${base01};
}

QDialog QToolButton:pressed {
    background-color: qlineargradient(spread:pad, x1:0, y1:0, x2:0, y2:1, stop:0 #${base03}, stop:1 #${base03});
}


/*==================================================================================================
Tool button inside Task Panel content that works as QPushButtons
==================================================================================================*/
/* found inside Part Design Workbench and "make a draft on a face" Task panel options */
QSint--ActionGroup QFrame[class="content"] QToolButton {
    color: #${base04};
    text-align: center;
    background-color: qlineargradient(spread:pad, x1:0, y1:0.3, x2:0, y2:1, stop:0 #${base02}, stop:1 #${base02});
    border: 1px solid #${base02};
    border-bottom-color: #${base02}; /* simulates shadow under the button */
    padding: 2px 6px; /* different than regular QPushButton */
    margin: 2px; /* different than regular QPushButton */
    min-height: 16px; /* same as QTabBar QPushButton min-width */
    border-radius: 4px;
}

QSint--ActionGroup QFrame[class="content"] QToolButton:hover,
QSint--ActionGroup QFrame[class="content"] QToolButton:focus {
    color: #${base0C};
    border-color: #${base03};
    background-color: qlineargradient(spread:pad, x1:0, y1:0, x2:0, y2:1, stop:0 #${base03}, stop:1 #${base03});
}

QSint--ActionGroup QFrame[class="content"] QToolButton:disabled,
QSint--ActionGroup QFrame[class="content"] QToolButton:disabled:checked {
    color: #${base01};
    border-color: #${base01};
    background-color: #${base01};
}

QSint--ActionGroup QFrame[class="content"] QToolButton:pressed {
    background-color: qlineargradient(spread:pad, x1:0, y1:0, x2:0, y2:1, stop:0 #${base03}, stop:1 #${base03});
}


/*==================================================================================================
QComboBox inside Task Panel content
==================================================================================================*/
/* Fix for QComboBox inside Task Panel due to not correctly styling it with regular */
/* found inside TechDraw Workbench and "insert multiple views" from toolbar */
/* TODO: external border not working, in the rest of GUI works setting up Qmenu background color but inside Task Panel it doesn't... */
QSint--ActionGroup QFrame[class="content"] QMenu,
QSint--ActionGroup QFrame[class="content"] QMenu::item {
    background-color: #${base01};
}

QSint--ActionGroup QFrame[class="content"] QComboBox QAbstractItemView {
    background-color: #${base01};
}


/*==================================================================================================
Radio button
==================================================================================================*/
QRadioButton::indicator:unchecked{
    color: #${base02};
    background-color: rgba(0,0,0,40);
    border: 1px solid #${base04};
}

QRadioButton::indicator:checked {
    background-color: #${base04}; /* QCheckBox has the same color */
    border: 1px solid #${base04}; /* QCheckBox has the same color */
    image:url(qss:images_dark-light/radiobutton_light.svg);
}

QRadioButton,
QRadioButton:disabled {
    color: #${base05};
    padding: 3px;
    outline: none;
    background-color: transparent;
}

QRadioButton:disabled {
    color: rgba(255,255,255,40);
}

QRadioButton::indicator {
    width: 11px;
    height: 11px;
    border-radius: 6px;
}

QRadioButton::indicator:pressed {
    border-color: #${base07};
}

QRadioButton::indicator:disabled {
    color: #${base01};
    background-color: transparent;
    border: 1px solid #${base01};
    image:url(qss:images_dark-light/radiobutton_dark.svg);
}

QRadioButton:focus {
    border: 1px solid #${base03};
}


/*==================================================================================================
Checkbox
==================================================================================================*/
QCheckBox,
QCheckBox:disabled {
    color: #${base05};
    padding: 3px;
    outline: none;
    background-color: transparent;
}

QCheckBox::indicator,
QGroupBox::indicator {
    color: #${base02};
    background-color: rgba(0,0,0,40);
    border: 1px solid #${base04};
    width: 11px;
    height: 11px;
    border-radius:2px;
}

QCheckBox::indicator:pressed,
QCheckBox::indicator:non-exclusive:checked:pressed,
QCheckBox::indicator:indeterminate:pressed,
QCheckBox::indicator:checked:pressed,
QGroupBox::indicator:pressed,
QGroupBox::indicator:non-exclusive:checked:pressed,
QGroupBox::indicator:indeterminate:pressed,
QGroupBox::indicator:checked:pressed {
    border-color: #${base07};
}

QCheckBox::indicator:checked,
QGroupBox::indicator:checked {
    background-color: #${base04}; /* QRadioButton has the same color */
    border: 1px solid #${base04}; /* QRadioButton has the same color */
    image:url(qss:images_dark-light/checkbox_light.svg);
}

QCheckBox:disabled {
    color: rgba(255,255,255,40);
    background-color: transparent;
}

QCheckBox::indicator:disabled,
QGroupBox::indicator:disabled {
    background-color: rgba(0,0,0,0);
    border: 1px solid rgba(0,0,0,20);
}

QCheckBox::indicator:indeterminate,
QGroupBox::indicator:indeterminate {
    background-color: #${base04};
    border: 1px solid #${base04};
    image: url(qss:images_dark-light/checkbox_indeterminate_light.svg);
}

QCheckBox:focus {
    border: 1px solid #${base03};
}


/*==================================================================================================
Checkboxs inside QListWidget and QTreeView
==================================================================================================*/
QListWidget::indicator,
QTreeView::indicator {
    color: #ff8888;
    background-color: rgba(255,255,255,20);
    border: 1px solid #${base01};
    width: 11px;
    height: 11px;
    border-radius:2px;
}

/* fix for QTreeView::indicator losing its margin */
QTreeView::indicator {
    margin: 3px;
}

QListWidget::indicator:selected,
QTreeView::indicator:selected {
    background-color: #e6e6e6;
}

QListWidget::indicator:checked:selected,
QListWidget::indicator:indeterminate:selected,
QTreeView::indicator:checked:selected,
QTreeView::indicator:indeterminate:selected {
    background-color: #${base04}; /* slightly lighter than default */
    border-color: #${base04}; /* slightly darker than default */
}

QListWidget::indicator:pressed,
QListWidget::indicator:non-exclusive:checked:pressed,
QListWidget::indicator:indeterminate:pressed,
QListWidget::indicator:checked:pressed,
QTreeView::indicator:pressed,
QTreeView::indicator:non-exclusive:checked:pressed,
QTreeView::indicator:indeterminate:pressed,
QTreeView::indicator:checked:pressed {
    border-color: #${base07};
}

QListWidget::indicator:checked,
QTreeView::indicator:checked {
    background-color: #${base04}; /* QRadioButton has the same color */
    border: 1px solid #${base04}; /* QRadioButton has the same color */
    image:url(qss:images_dark-light/checkbox_light.svg);
}

QListWidget::indicator:disabled,
QTreeView::indicator:disabled {
    background-color: rgba(255,255,255,20);
    border: 1px solid rgba(255,255,255,20);
}

QListWidget::indicator:indeterminate,
QTreeView::indicator:indeterminate {
    background-color: #${base04};
    border: 1px solid #${base04};
    image: url(qss:images_dark-light/checkbox_indeterminate_light.svg);
}


/*==================================================================================================
Slider
==================================================================================================*/
QSlider,
QSlider:active,
QSlider:!active {
    border: none;
    background-color: transparent;
}

QSlider:horizontal {
    padding: 0px 10px;
}

QSlider:vertical {
    padding: 10px 0px;
}

QSlider::groove {
    background-color: rgba(255,255,255,30);
    border: 1px solid rgba(255,255,255,40);
    border-radius: 5px;
    margin: 4px 0px;
}

QSlider::groove:horizontal {
    height: 8px;
}

QSlider::groove:vertical {
    width: 8px;
}

QSlider::groove:horizontal:disabled,
QSlider::groove:vertical:disabled {
    border-color:  #${base01};
    background-color: #${base01};
}

QSlider::handle:horizontal,
QSlider::handle:vertical {
    background-color: #${base01};
    border: 1px solid #${base01};
    width: 14px;
    height: 14px;
    border-radius: 8px;
}

QSlider::handle:horizontal {
    margin: -4px 0;
}

QSlider::handle:vertical {
    margin: 0 -4px;
}

QSlider::handle:horizontal:hover,
QSlider::handle:vertical:hover,
QSlider::handle:horizontal:pressed,
QSlider::handle:vertical:pressed {
    border-color: #${focused};
    background-color: #${base04};
}

QSlider::handle:horizontal:disabled,
QSlider::handle:vertical:disabled {
    border-color: #${base01};
    background-color: #${base01};
}


/*==================================================================================================
Toolbar buttons
==================================================================================================*/
/*QToolBar > QComboBox,   disabled because creates different margins for body and drop-down button */
QToolBar > QAbstractSpinBox,
QToolBar > QSpinBox,
QToolBar > QDoubleSpinBox,
QToolBar > QLineEdit,
QToolBar > QTextEdit,
QToolBar > QTimeEdit,
QToolBar > QDateEdit,
QToolBar > QDateTimeEdit {
    margin: 0px 2px;
    padding: 0px;
    min-width: 70px; /* necessary to show its content */
}

QToolBar > QComboBox,
QToolBar > QAbstractSpinBox,
QToolBar > QSpinBox,
QToolBar > QDoubleSpinBox,
QToolBar > QLineEdit,
QToolBar > QTextEdit,
QToolBar > QTimeEdit,
QToolBar > QDateEdit,
QToolBar > QDateTimeEdit {
    min-height: 0px; /* reset it inside Tool Bar due to the user ability to set the "size of toolbar icons" inside Preferences  */
}

QToolBar > QPushButton {
    padding: 0px;
    margin: 1px; /* doesn't work with :left, :right:, :top or :bottom sub-controls */
    min-width: 16px; /* could not be larger due to switchable Preferences "Size of toolbar icons" */
    min-height: 16px; /* could not be larger due to switchable Preferences "Size of toolbar icons" */
    border-radius: 4px; /* same as regular QPushButton */
}

QToolBar > QPushButton:checked {
    border: 1px solid #${base03};
    background-color: qlineargradient(spread:pad, x1:0, y1:0, x2:0, y2:1, stop:0 #${base03}, stop:1 #ff0000);
}

QToolBar > QPushButton:!checked {
    background-color: qlineargradient(spread:pad, x1:0, y1:0.3, x2:0, y2:1, stop:0 #${base06}, stop:1 #${base06});
    border: 1px solid #${base01};
    border-bottom-color: #${base01}; /* simulates shadow under the button */
}

QToolBar > QPushButton:checked:hover {
    border-color: #00ffff;
}

QToolBar > QPushButton:!checked:hover {
    color: #${base07};
    border-color: #${base01};
}

QToolBar > QPushButton:checked:pressed {
    background-color: #${base04};
}

QToolBar > QPushButton:!checked:pressed {
    background-color: qlineargradient(spread:pad, x1:0, y1:0, x2:0, y2:1, stop:0 #${base06}, stop:1 #${base06});
}

QToolBar > QPushButton:checked:disabled,
QToolBar > QPushButton:!checked:disabled {
    border: none;
    background-color: transparent;
}

QToolBar > QToolButton {
    margin: 2px;
    padding: 2px;
    border-radius: 3px;
}

QToolBar > QToolButton:hover {
    background-color: rgba(255,255,255,20);
}

QToolBar > QToolButton:pressed {
    background-color: rgba(255,255,255,30);
}

/* ToolBar menu buttons (buttons with drop-down menu) */
QToolBar > QToolButton#qt_toolbutton_menubutton {
    padding-right: 20px; /* Hack to add more width to buttons with menu */
    border: 1px solid transparent;
    border-radius: 3px;
}

QToolBar > QToolButton#qt_toolbutton_menubutton:hover,
QToolBar > QToolButton#qt_toolbutton_menubutton:pressed,
QToolBar > QToolButton#qt_toolbutton_menubutton:open {
    border: 1px solid #${base03};
}

QToolBar QToolButton::menu-button,
QToolBar > QToolButton#qt_toolbutton_menubutton::menu-button {
    border: none;
    border-top-right-radius: 3px;
    border-bottom-right-radius: 3px;
    width: 16px; /* 16px width + 4px for border = 20px allocated above */
    outline: none;
    background-color: transparent;
}

QToolBar > QToolButton#qt_toolbutton_menubutton::menu-button:hover,
QToolBar > QToolButton#qt_toolbutton_menubutton::menu-button:pressed,
QToolBar > QToolButton#qt_toolbutton_menubutton::menu-button:open {
    background-color: qlineargradient(spread:pad, x1:1, y1:0.8, x2:1, y2:0, stop:0 #${base04}, stop:1 #${base03});
}

QToolBar > QToolButton::menu-arrow {
    background-image: url(qss:images_dark-light/down_arrow_light.svg);
    background-position: center center;
    background-repeat: none;
    subcontrol-origin: padding;
    subcontrol-position: bottom right;
    height: 10px; /* same as arrow image */
}

QToolBar > QToolButton::menu-arrow:hover {
    background-image: url(qss:images_dark-light/down_arrow_lighter.svg);
}

QToolBar > QToolButton::menu-arrow:open {
    background-image: url(qss:images_dark-light/down_arrow_lighter.svg);
}

/* when QToolButton is checked: */
QToolBar > QToolButton:checked {
    border: 1px solid #${base03};
    background-color: rgba(124,171,249,60); /* transparency for #${base03} color */
}

QToolBar > QToolButton:checked:hover {
    border: 1px solid #${base03};
    background-color: rgba(124,171,249,80); /* transparency for #${base03} color */
}

/*The "show more" button  (it can also be stylable with "QToolBarExtension" */
QToolBar QToolButton#qt_toolbar_ext_button {
    margin: 1px;
    padding: 0px;
    padding-left:1px;
    padding-right:1px;
    qproperty-icon: url(qss:images_dark-light/right_arrow_light.svg);
    image: transparent;
    background-repeat: none;
    background-position: center left;
}

QToolBar QToolButton#qt_toolbar_ext_button:hover {
    qproperty-icon: url(qss:images_dark-light/right_arrow_lighter.svg);
    border-color: #${base01};
    background-color: rgba(255,255,255,20)}

QToolBar QToolButton#qt_toolbar_ext_button:on {
    qproperty-icon: url(qss:images_dark-light/right_arrow_lighter.svg);
    border-color: #${base01};
    background-color: #${base04};
}


/*==================================================================================================
Tables (spreadsheets)
==================================================================================================*/
QTableView {
    gridline-color: #44475a;
    selection-color: #${base03};
    selection-background-color: #${focused};
}

QTableView::item:disabled  {
    color: #${base01};
}

QTableView::item:selected  {
    color: #${base07};
    border-color: #${base07}; /* same as focused background color*/
    border-bottom-color: #${base03}; /* same as focused border color */
    background-color: #${base04}; /* must be defined?: aliased cells default to "regular" color when selected if this style is not explicitly set*/
}

/* fix for elements inside the cells */
QTableView > QWidget > QComboBox,
QTableView > QWidget > QAbstractSpinBox,
QTableView > QWidget > QSpinBox,
QTableView > QWidget > QDoubleSpinBox,
QTableView > QWidget > QLineEdit,
QTableView > QWidget > QTextEdit,
QTableView > QWidget > QTimeEdit,
QTableView > QWidget > QDateEdit,
QTableView > QWidget > QDateTimeEdit,
QTableView > QWidget > QComboBox:drop-down,
QTableView > QWidget > QAbstractSpinBox:up-button,
QTableView > QWidget > QSpinBox:up-button,
QTableView > QWidget > QDoubleSpinBox:up-button,
QTableView > QWidget > QTimeEdit:up-button,
QTableView > QWidget > QDateEdit:up-button,
QTableView > QWidget > QDateTimeEdit:up-button,
QTableView > QWidget > QAbstractSpinBox:down-button,
QTableView > QWidget > QSpinBox:down-button,
QTableView > QWidget > QDoubleSpinBox:down-button,
QTableView > QWidget > QTimeEdit:down-button,
QTableView > QWidget > QDateEdit:down-button,
QTableView > QWidget > QDateTimeEdit:down-button,
QTableView > QWidget > Gui--ColorButton {
    border-radius: 0px;
}

QTableView > QWidget > QComboBox,
QTableView > QWidget > QAbstractSpinBox,
QTableView > QWidget > QSpinBox,
QTableView > QWidget > QDoubleSpinBox,
QTableView > QWidget > QLineEdit,
QTableView > QWidget > QTextEdit,
QTableView > QWidget > QTimeEdit,
QTableView > QWidget > QDateEdit,
QTableView > QWidget > QDateTimeEdit {
    color: #${base02};
    background-color: transparent;
    border-color: transparent;
}

QTableView > QWidget > QComboBox:drop-down,
QTableView > QWidget > QAbstractSpinBox:up-button,
QTableView > QWidget > QSpinBox:up-button,
QTableView > QWidget > QDoubleSpinBox:up-button,
QTableView > QWidget > QTimeEdit:up-button,
QTableView > QWidget > QDateEdit:up-button,
QTableView > QWidget > QDateTimeEdit:up-button,
QTableView > QWidget > QAbstractSpinBox:down-button,
QTableView > QWidget > QSpinBox:down-button,
QTableView > QWidget > QDoubleSpinBox:down-button,
QTableView > QWidget > QTimeEdit:down-button,
QTableView > QWidget > QDateEdit:down-button,
QTableView > QWidget > QDateTimeEdit:down-button,
QTableView > QWidget > Gui--ColorButton {
    background-color: rgba(0,0,0,30);
}

QTableView > QWidget > QComboBox:focus,
QTableView > QWidget > QAbstractSpinBox:focus,
QTableView > QWidget > QSpinBox:focus,
QTableView > QWidget > QDoubleSpinBox:focus,
QTableView > QWidget > QLineEdit:focus,
QTableView > QWidget > QTextEdit:focus,
QTableView > QWidget > QTimeEdit:focus,
QTableView > QWidget > QDateEdit:focus,
QTableView > QWidget > QDateTimeEdit:focus {
    color: #${base03};
    selection-color: #${base0C};
    selection-background-color: #${base04};
    border-color: #${base07};
    background-color: #${base07};
}

QTableView > QWidget > QComboBox:disabled,
QTableView > QWidget > QAbstractSpinBox:disabled,
QTableView > QWidget > QSpinBox:disabled,
QTableView > QWidget > QDoubleSpinBox:disabled,
QTableView > QWidget > QLineEdit:disabled,
QTableView > QWidget > QTextEdit:disabled,
QTableView > QWidget > QTimeEdit:disabled,
QTableView > QWidget > QDateEdit:disabled,
QTableView > QWidget > QDateTimeEdit:disabled {
    color: rgba(0,0,0,120);
    background-color: transparent;
    border-color: transparent;
}

QTableView > QWidget > QComboBox:read-only,
QTableView > QWidget > QAbstractSpinBox:read-only,
QTableView > QWidget > QSpinBox:read-only,
QTableView > QWidget > QDoubleSpinBox:read-only,
QTableView > QWidget > QLineEdit:read-only,
QTableView > QWidget > QTextEdit:read-only,
QTableView > QWidget > QTimeEdit:read-only,
QTableView > QWidget > QDateEdit:read-only,
QTableView > QWidget > QDateTimeEdit:read-only {
    color: #${base02};
    background-color: transparent;
    border-color: transparent;
}


/*==================================================================================================
SELECTORTOOLBAR widget (3rd party plugin)
==================================================================================================*/
QToolBar:horizontal#Selector,
QToolBar:vertical#Selector {
    background-color: rgba(0,0,0,120);
    margin: 0px;
    padding: 0px;
}

QToolBar::handle:top#Selector,
QToolBar::handle:bottom#Selector,
QToolBar::handle:horizontal#Selector {
    alignment: bottom left;
}

QToolBar::handle:left#Selector,
QToolBar::handle:right#Selector,
QToolBar::handle:vertical#Selector {
    width: 100%;
    alignment: center left;
}

QToolBar:top#Selector QToolButton,
QToolBar:bottom#Selector QToolButton,
QToolBar:horizontal#Selector QToolButton {
    alignment: bottom left;
}

QToolBar:left#Selector QToolButton,
QToolBar:right#Selector QToolButton,
QToolBar:vertical#Selector QToolButton {
    alignment: center left;
}

QToolButton[toolbar_orientation="horizontal"] {
    /* nothing, when Horizontal there's no need to add special parameters */
}

QToolButton[toolbar_orientation="vertical"] {
    /* nothing, when Horizontal there's no need to add special parameters */
}

QToolBar#Selector QToolButton {
    border: none;
    margin: 0px;
    padding: 2px 6px;
    border-radius: 0px;
}

/* Active tab */
QToolBar#Selector QToolButton:checked {
    color: #${base0C};
    background-color: #${base01};
}

/* Unactive tabs */
QToolBar#Selector QToolButton:!checked {
    color: rgba(255,255,255,160);
    background-color: transparent;
    margin: 0px;
}

/* Unactive tabs (hover) */
QToolBar#Selector QToolButton:!checked:hover {
    color: rgba(255,255,255,255);
    background-color: rgba(255,255,255,20);
}

/* Unactive tabs (pressed) */
QToolBar#Selector QToolButton:!checked:pressed {
    background-color: rgba(255,255,255,40);
}


/*==================================================================================================
TABBAR widget (3rd party plugin)
==================================================================================================*/
QTabWidget#TabBar > QTabBar {
    border-top: 0;
}

QTabWidget#TabBar > QTabBar::tab:top,
QTabWidget#TabBar > QTabBar::tab:bottom {
    min-width: -1;
}

QTabWidget#TabBar > QTabBar::tab:left,
QTabWidget#TabBar > QTabBar::tab:right {
    min-height: -1;
}


/*==================================================================================================
EXPERIMENTAL
==================================================================================================*/

/* Fix for preventing elements in different rows to accidentally overlap */
QDialog QGroupBox QFrame {
    margin: 2px 0px;
}

*[mandatoryField="true"] { background-color: cyan }

/* Hack to avoid QPushButton text partially hidden under menu-indicator */
QPushButton#NavigationIndicator::menu-indicator {
    image: none;
    width: 0px;
}

QToolBar QToolButton[popupMode="1"] {
    width: 100px;
    background: red;
}
    '';
in {
  home.file.".local/share/FreeCAD/Mod/Dracula/Dracula/Dracula.qss".text =
    qssContent;
}
