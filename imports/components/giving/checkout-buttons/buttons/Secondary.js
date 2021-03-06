// @flow

type ISecondaryButton = {
  onClick: Function,
  disabled?: boolean,
};

const SecondaryButton = ({ disabled = false, onClick }: ISecondaryButton) => {
  const classes = [
    "btn--thin",
    "btn--small",
    "display-inline-block",
    "push-left@lap-and-up",
    "push-half-left@handheld",
  ];
  let style = {};

  if (disabled) {
    classes.push("btn--disabled");
    // this should be fixed in junction
    style = {
      backgroundColor: "transparent !important", // handle hover :(
    };
  } else {
    classes.push("btn--dark-tertiary");
  }

  return (
    <button
      style={style}
      disabled={disabled}
      className={classes.join(" ")}
      onClick={onClick}
    >
      Register
    </button>
  );
};

export default SecondaryButton;
