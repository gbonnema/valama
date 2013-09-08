/*
 * guanako/guanako_refactoring.vala
 * Copyright (C) 2013, Valama development team
 *
 * Valama is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Valama is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */
using Vala;

namespace Guanako.Refactoring {
    public static Symbol? find_declaration (Project project, SourceFile sf, int line, int col) {

        var smb = project.get_symbol_at_pos(sf, line, col);
        if (smb is Vala.Subroutine) {
            var sr = smb as Vala.Subroutine;
            Vala.Statement st = null;
            Guanako.iter_subroutine (sr, (stmt, depth)=>{
                if (!Guanako.inside_source_ref (sf, line, col, stmt.source_reference))
                    return Guanako.IterCallbackReturns.ABORT_BRANCH;
                st = stmt;
                return Guanako.IterCallbackReturns.CONTINUE;
            });
            //if (st == null)
            //    stdout.printf("Statement null\n");
            if (st != null) {
                Vala.Expression expression = null;
                Guanako.iter_expressions (st, (expr, depth)=>{
                    if (!Guanako.inside_source_ref (sf, line, col, expr.source_reference))
                        return Guanako.IterCallbackReturns.ABORT_BRANCH;
                    //stdout.printf("!expr:" + expression.to_string() + "\n");
                    //stdout.printf("!src ref:" + expression.source_reference.to_string() + "\n");
                    expression = expr;
                    return Guanako.IterCallbackReturns.CONTINUE;
                });
                //stdout.printf("smb ref:" + expression.symbol_reference.to_string() + "\n");
                return expression.symbol_reference;
            }
        }
        return null;
    }
}

// vim: set ai ts=4 sts=4 et sw=4