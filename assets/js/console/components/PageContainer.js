import React, { useEffect } from "react";
import { useSelector, useDispatch } from "react-redux";

import { refreshClubs } from "../actions";
import Header from "./Header";

export default ({ children }) => {
  const disptch = useDispatch();
  const { menuTitle } = useSelector(state => state.root);

  useEffect(() => {
    disptch(refreshClubs());
  }, []);

  return (
    <div className="flex md:px-20 lg:px-48 xl:px-64 bg-white">
      <Header className="w-22 md:w-4/12 max-h-screen min-h-screen" />
      <main className="flex-1 md:w-8/12 border-l border-r border-b">
        <div className="border-b p-4">
          <h1 className="text-xl font-bold">{menuTitle}</h1>
        </div>
        <div className="bg-gray-200">{children}</div>
      </main>
    </div>
  );
};
