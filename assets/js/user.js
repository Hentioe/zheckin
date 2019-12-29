// 导入样式
import "../scss/user.scss";
// Polyfills
import "mdn-polyfills/Object.assign";
import "mdn-polyfills/Array.prototype.includes";
import "mdn-polyfills/String.prototype.startsWith";
import "mdn-polyfills/String.prototype.includes";
import "mdn-polyfills/NodeList.prototype.forEach";
import "mdn-polyfills/Element.prototype.classList";

import React from "react";
import ReactDOM from "react-dom";
import { Provider as ReduxProvider, useSelector } from "react-redux";
import reduxLogger from "redux-logger";
import thunkMiddleware from "redux-thunk";
import { configureStore } from "@reduxjs/toolkit";
import { BrowserRouter as Router, Switch, Route } from "react-router-dom";
import { HelmetProvider } from "react-helmet-async";

// 导入页面和组件
import { Header, Footer, MainContainer } from "./user/components";
import { Index } from "./user/pages";

// 创建 Redux store
import Reducers from "./user/reducers";
const DEBUG = process.env.NODE_ENV == "development";
const middlewares = [thunkMiddleware, DEBUG && reduxLogger].filter(Boolean);
const store = configureStore({
  reducer: Reducers,
  middleware: middlewares
});

const Root = () => {
  const { className, style, footerHidden, headerHidden } = useSelector(
    state => state.root
  );

  return (
    <div className={className} style={style}>
      <Header headerHidden={headerHidden} />
      <MainContainer headerHidden={headerHidden}>
        <Switch>
          <Route path="/">
            <Index />
          </Route>
        </Switch>
      </MainContainer>
      <Footer footerHidden={footerHidden} />
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
