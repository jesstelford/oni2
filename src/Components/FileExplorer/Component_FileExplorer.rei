open Oni_Core;

// MODEL

[@deriving show]
type msg;

module Msg: {let activeFileChanged: option(FpExp.t(FpExp.absolute)) => msg;};

type model;

let initial: (~rootPath: FpExp.t(FpExp.absolute)) => model;
let setRoot: (~rootPath: FpExp.t(FpExp.absolute), model) => model;
let root: model => FpExp.t(FpExp.absolute);

let keyPress: (string, model) => model;

let reload: model => model;

let getFileIcon:
  (~languageInfo: Exthost.LanguageInfo.t, ~iconTheme: IconTheme.t, string) =>
  option(IconTheme.IconDefinition.t);

// UPDATE

type outmsg =
  | Nothing
  | Effect(Isolinear.Effect.t(msg))
  | OpenFile(string)
  | PreviewFile(string)
  | GrabFocus
  | WatchedPathChanged({
      path: FpExp.t(FpExp.absolute),
      stat: option(Luv.File.Stat.t),
    });

let update:
  (
    ~config: Config.resolver,
    ~configuration: Feature_Configuration.model,
    msg,
    model
  ) =>
  (model, outmsg);

// SUBSCRIPTION

let sub:
  (
    ~config: Config.resolver,
    ~configuration: Feature_Configuration.model,
    model
  ) =>
  Isolinear.Sub.t(msg);

// VIEW

module View: {
  let make:
    (
      ~config: Config.resolver,
      ~isFocused: bool,
      ~iconTheme: IconTheme.t,
      ~languageInfo: Exthost.LanguageInfo.t,
      ~model: model,
      ~decorations: Feature_Decorations.model,
      ~theme: ColorTheme.Colors.t,
      ~font: UiFont.t,
      ~expanded: bool,
      ~onRootClicked: unit => unit,
      ~dispatch: msg => unit,
      unit
    ) =>
    Revery.UI.element;
};

module Contributions: {
  let configuration: list(Config.Schema.spec);
  let commands: (~isFocused: bool) => list(Command.t(msg));
  let contextKeys: (~isFocused: bool, model) => WhenExpr.ContextKeys.t;
};
