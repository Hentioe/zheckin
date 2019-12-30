import { setClassName, setStyle } from "./slices/root";

export function setRootClassName(className) {
  return dispatch => dispatch(setClassName(className));
}

export function setRootStyle(style) {
  return dispatch => dispatch(setStyle(style));
}
