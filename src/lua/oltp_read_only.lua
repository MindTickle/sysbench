#!/usr/bin/env sysbench
-- Copyright (C) 2006-2017 Alexey Kopytov <akopytov@gmail.com>

-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software
-- Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA

-- ----------------------------------------------------------------------
-- Read-Only OLTP benchmark
-- ----------------------------------------------------------------------

--[[
   If you run into these problems-
   1. ld: library not found for -lssl,
   https://stackoverflow.com/questions/25979525/cannot-find-lssl-cannot-find-lcrypto-when-installing-mysql-python-using-mar
   2. ld: library not found for -lgcc, export MACOSX_DEPLOYMENT_TARGET=10.10
]]--
require("oltp_common")

local unique_id = tostring( {} ):sub(8)

-- Marker 9
function prepare_statements()
--   print("ThreadId "..unique_id.." preparing statements...\n")
   prepare_point_selects()

   if not sysbench.opt.skip_trx then
      prepare_begin()
      prepare_commit()
   end

   if sysbench.opt.range_selects then
      prepare_simple_ranges()
      --prepare_sum_ranges()
      prepare_order_ranges()
      prepare_distinct_ranges()
   end
end

-- Marker 13
function event()
   if not sysbench.opt.skip_trx then
      begin()
   end

   execute_point_selects()

   if sysbench.opt.range_selects then
      execute_simple_ranges()
      execute_sum_ranges()
      execute_order_ranges()
      execute_distinct_ranges()
   end

   if not sysbench.opt.skip_trx then
      commit()
   end

   check_reconnect()
end
