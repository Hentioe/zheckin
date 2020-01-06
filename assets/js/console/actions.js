import { setClubs, setMenuTitle } from "./slices/root";
import unfetch from "unfetch";

export function refreshClubs() {
  return disptch => {
    unfetch("/console/api/clubs/joined")
      .then(r => r.json())
      .then(json => {
        disptch(setClubs(json.data.clubs));
      });
  };
}

export function syncClubs() {
  return disptch => {
    unfetch("/console/api/accounts/refresh_joined_clubs", { method: "PUT" })
      .then(r => r.json())
      .then(json => {
        disptch(setClubs(json.data.clubs));
      });
  };
}

export { setClubs, setMenuTitle };
