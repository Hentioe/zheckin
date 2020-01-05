import React from "react";

import Header from "./Header";

export default ({ children }) => {
  return (
    <div className="flex md:px-20 lg:px-48 xl:px-64">
      <Header className="w-18 md:w-3/12 max-h-screen min-h-screen" />
      <main className="bg-gray-200 flex-1 p-4">{children}</main>
    </div>
  );
};
