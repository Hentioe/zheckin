import { createSlice } from "@reduxjs/toolkit";

const initialState = {
  clubs: [],
  menuTitle: "无操作"
};

const rootSlice = createSlice({
  name: "root",
  initialState,
  reducers: {
    setClubs: (state, action) =>
      Object.assign({}, state, { clubs: action.payload }),
    setMenuTitle: (state, action) =>
      Object.assign({}, state, { menuTitle: action.payload })
  }
});

export const { setClubs, setMenuTitle } = rootSlice.actions;

export default rootSlice.reducer;
