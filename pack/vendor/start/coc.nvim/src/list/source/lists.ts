'use strict'
import Mru from '../../model/mru'
import { toText } from '../../util/string'
import BasicList from '../basic'
import { formatListItems, UnformattedListItem } from '../formatting'
import { IList, ListContext, ListItem } from '../types'

export default class ListsList extends BasicList {
  public readonly name = 'lists'
  public readonly defaultAction = 'open'
  public readonly description = 'registered lists of coc.nvim'
  private mru: Mru = new Mru('lists')

  constructor(private readonly listMap: Map<string, IList>) {
    super()

    this.addAction('open', async item => {
      let { name } = item.data
      await this.mru.add(name)
      setTimeout(() => {
        this.nvim.command(`CocList ${name}`, true)
      }, 50)
    })
  }

  public async loadItems(_context: ListContext): Promise<ListItem[]> {
    let items: UnformattedListItem[] = []
    let mruList = await this.mru.load()
    for (let list of this.listMap.values()) {
      if (list.name == 'lists') continue
      items.push({
        label: [list.name, toText(list.description)],
        data: {
          name: list.name,
          interactive: list.interactive,
          score: mruScore(mruList, list.name)
        }
      })
    }
    items.sort((a, b) => b.data.score - a.data.score)
    return formatListItems(this.alignColumns, items)
  }

  public doHighlight(): void {
    let { nvim } = this
    nvim.pauseNotification()
    nvim.command('syntax match CocListsDesc /\\t.*$/ contained containedin=CocListsLine', true)
    nvim.command('highlight default link CocListsDesc Comment', true)
    nvim.resumeNotification(false, true)
  }
}

export function mruScore(list: string[], key: string): number {
  let idx = list.indexOf(key)
  return idx == -1 ? -1 : list.length - idx
}
