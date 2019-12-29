import { combineReducers } from "redux";

import rootReducer from "./slices/root";

export default combineReducers({ root: rootReducer });
