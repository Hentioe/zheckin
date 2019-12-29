import { createSlice } from "@reduxjs/toolkit";

const initialState = {
  className: "bg-transparent",
  style: {},
  headerHidden: false,
  footerHidden: false
};

const rootSlice = createSlice({
  name: "root",
  initialState,
  reducers: {
    setClassName: (state, action) =>
      Object.assign({}, state, { className: action.payload }),
    setStyle: (state, action) =>
      Object.assign({}, state, { style: action.payload }),
    hiddenHeader: state => Object.assign({}, state, { headerHidden: true }),
    showHeader: state => Object.assign({}, state, { headerHidden: false }),
    hiddenFooter: state => Object.assign({}, state, { footerHidden: true }),
    showFooter: state => Object.assign({}, state, { footerHidden: false })
  }
});

export const {
  setClassName,
  setStyle,
  hiddenHeader,
  hiddenFooter,
  showHeader,
  showFooter
} = rootSlice.actions;

export default rootSlice.reducer;
