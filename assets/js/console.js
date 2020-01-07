// 导入样式
import "../scss/console.scss";

import React from "react";
import ReactDOM from "react-dom";
import { Provider as ReduxProvider } from "react-redux";
import reduxLogger from "redux-logger";
import thunkMiddleware from "redux-thunk";
import { configureStore } from "@reduxjs/toolkit";
import { BrowserRouter as Router, Switch, Route } from "react-router-dom";
import { HelmetProvider } from "react-helmet-async";

// 导入页面和组件
import { PageContainer } from "./console/components";
import { Settings, Today } from "./console/pages";

// 创建 Redux store
import Reducers from "./console/reducers";
const DEBUG = process.env.NODE_ENV == "development";
const middlewares = [thunkMiddleware, DEBUG && reduxLogger].filter(Boolean);
const store = configureStore({
  reducer: Reducers,
  middleware: middlewares
});

const Root = () => {
  // const _ = useSelector(state => state.root);

  return (
    <div>
      <PageContainer>
        <Switch>
          <Route exact path="/console/settings">
            <Settings />
          </Route>
          <Route exact path="/console/today">
            <Today />
          </Route>
        </Switch>
      </PageContainer>
    </div>
  );
};

const App = () => {
  return (
    <ReduxProvider store={store}>
      <HelmetProvider>
        <Router>
          <Root />
        </Router>
      </HelmetProvider>
    </ReduxProvider>
  );
};

ReactDOM.render(<App />, document.getElementById("app"));
