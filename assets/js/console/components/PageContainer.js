import React from "react";

import Header from "./Header";

export default ({ children }) => {
  return (
    <div className="flex md:px-20 lg:px-48 xl:px-64 bg-white">
      <Header className="w-22 md:w-4/12 max-h-screen min-h-screen" />
      <main className="flex-1 md:w-8/12 border-l border-r border-b">
        <div className="border-b p-4">
          <h1 className="text-xl font-bold">设置页面</h1>
        </div>
        <div className="bg-gray-200">{children}</div>
      </main>
    </div>
  );
};
