;;; dap-node.el --- Debug Adapter Protocol mode for Node      -*- lexical-binding: t; -*-


;; Author: Ury Marshak
;; Keywords: languages

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;; URL: https://github.com/yyoncho/dap-mode
;; Package-Requires: ((emacs "25.1") (dash "2.14.1") (lsp-mode "4.0"))
;; Version: 0.2

;;; Commentary:
;; Adapter for vscode-node-debug2

;;; Code:

(require 'dap-mode)

(defcustom dap-node-debug-program `("node" ,(expand-file-name "~/work/vscode-node-debug2/out/src/nodeDebug.js"))
  "The path to the node debugger."
  :group 'dap-node
  :type '(repeat string))

(defun dap-node--populate-start-file-args (conf)
  "Populate CONF with the required arguments."
  (-> conf
      (dap--put-if-absent :dap-server-path dap-node-debug-program)
      (dap--put-if-absent :type "Node")
      (dap--put-if-absent :cwd default-directory)
      (dap--put-if-absent :program (buffer-file-name))
      (dap--put-if-absent :name "Node Debug")))

(dap-register-debug-provider "node" 'dap-node--populate-start-file-args)
(dap-register-debug-template "Node Run Configuration"
                             (list :type "node"
                                   :cwd nil
                                   :request "launch"
                                   :program nil
                                   :name "Node::Run"))
(dap-register-debug-template "Node Attach"
                             (list :type "node"
                                   ;; :cwd nil
                                   :request "attach"
                                   :program nil
                                   :port 9229
                                   :name "Node:Attach"))

(dap-register-debug-template "Node npm run-script debug"
                             (list :type "node"
                                   ;; :cwd nil
                                   :request "launch"
                                   :program nil
                                   :runtimeExecutable "npm"
                                   :runtimeArgs '("run-script" "debug")
                                   :port 9229
                                   :name "Node:RunScript"))

(provide 'dap-node)
;;; dap-node.el ends here
