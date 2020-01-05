import React from "react";

import Header from "./Header";

export default ({ children }) => {
  return (
    <div className="flex md:px-20 lg:px-48 xl:px-64">
      <Header className="bg-red-200 w-3/12 p-2" />
      <main className="bg-gray-200 w-9/12 p-2">{children}</main>
    </div>
  );
};
